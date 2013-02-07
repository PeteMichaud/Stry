$(document).ready(function(){

    //Initialize

    var $story = $('#story-scene-list');
    var $toc = $('#toc');
    var $attachment_modal = $('#attachment-modal');
    var $attachment_form = $('form#new_attachment');
    var $picture_modal =  $('#picture-modal');
    var $picture_modal_img =  $('img', $picture_modal);

    current_block_id = null;
    $attachment = null;

    //Create Block Dropdowns

    get_block_klass_select_markup(populate_block_klass_selects);

    //Turn on Autogrow

    activate_autogrow($('textarea'));

    //Turn on WYSIWYG

    activate_wysiwyg($('.block-content'));

    // Attachment Related Code

    $story
    .on('click', '.attachment-thumb', function() {
        $picture_modal_img.attr('src', $(this).data('original-url'));
        $picture_modal.modal('show');
        return false;
    })

    .on('click', '.attachment-modal-btn', function(){
        current_block_id = $(this).parents('li.block').data('block-id');
        $previous_attachment = $(this).parents('li.add-attachment').prev();
        $('input[name="attachment[block_id]"]', $attachment_modal)
            .val(current_block_id);
        if ($previous_attachment.length)
        {
            $('input[name="previous_attachment"]', $attachment_modal)
                .val($previous_attachment.data('attachment-id'));
        }
            $attachment_modal.modal('show');
        return false;
    });

    $attachment_form
        .on("ajax:success", function(e, html){
            $attachment = $(html);
            insert_attachment($attachment);
        })
        .on('ajax:complete', function (form, e){
            $attachment = $(e.responseText);
            insert_attachment($attachment);
        });

    $('input[value="Attach"]', $attachment_form).click(function(){
        return $('#attachment_file', $attachment_form).val() != '';
    });

    $attachment_modal.on('hidden', function(){
        if ($attachment)
        {
            $attachment.slideDown(function(){
                ensure_block_height($attachment.parents('.block-attachment-list'));
            });
        }
    });

    function insert_attachment($attachment)
    {
        $attachment.hide();
        $('li[data-block-id="' + current_block_id + '"] ul.block-attachment-list li.add-attachment')
            .before($attachment);
        activate_autogrow($('textarea', $attachment));
        activate_jplayer_audio($('.audio-player', $attachment));
        activate_jplayer_video($('.video-player', $attachment));
        $attachment_modal.modal('hide');
        //show $attachment on modal.hidden event (See above this function)
    }

    // End Attachment Code

    //Sortable Code

    activate_block_sort($('.scene-block-list'));

    activate_attachment_sort($('.block-attachment-list'));

    $toc.sortable({
        axis: 'y',
        update: function(e, ui) {
            var $previous_toc_scene = $(ui.item).prev();

            $.ajax({
                type: 'PUT',
                url: '/scenes/' + $(ui.item).data('scene-id'),
                dataType: 'html',
                data: "previous_scene=" + ($previous_toc_scene.data('scene-id') || ''),
                error: error,
                success: function () {
                  $scene = $('#scene-'+$(ui.item).data('scene-id'));
                  $add_scene_li = $scene.next();
                  $previous_scene = $('#scene-'+$previous_toc_scene.data('scene-id'));

                  if ($previous_scene.length)
                  {
                    $previous_scene.after($scene).after($add_scene_li);
                  }
                  else
                  {
                      $story.prepend($scene).prepend($add_scene_li);
                  }
                }
            });
        }
    });

    // Add Scene, Block, Attachment

    $story
    .on('click', '.add-scene-btn', function(e){
        var $previous_scene = $(this).parents('li').prev('.scene');

        $.ajax({
            type: 'POST',
            url: '/scenes',
            dataType: 'html',
            data:
            {
                'scene[story_id]': $story.data('story-id'),
                'previous_scene': $previous_scene.data('scene-id')
            },
            error: error,
            success: function (html) {
                $new_scene = $(html);
                new_scene_id = $new_scene.filter('.scene').data('scene-id');
                $toc_link = $('<li data-scene-id="' + new_scene_id + '"><a href="#scene-'+ new_scene_id + '">[No Scene Title]</a></li>');

                if ($previous_scene.length)
                {
                    $previous_scene.after($new_scene);
                    $previous_toc_link = $('li[data-scene-id="'+ $previous_scene.data('scene-id') + '"]', $toc);
                    $previous_toc_link.after($toc_link);
                }
                else
                {
                    $story.prepend($new_scene);
                    $toc.prepend($toc_link);
                }

                activate_block_sort($new_scene.filter('.scene-block-list'));
            }
        });

        return false;

    })

    .on('click','.add-block-btn', function(e){
        var $scene = $(this).parents('li.scene');
        var $previous_block = $(this).parents('li').prev('.block');

        $.ajax({
            type: 'POST',
            url: '/blocks',
            dataType: 'html',
            data:
            {
                'block[scene_id]': $scene.data('scene-id'),
                'previous_block': $previous_block.data('block-id')
            },
            error: error,
            success: function (data) {
                $block_with_controls = $(data);
                $block = $block_with_controls.filter('.block');
                if ($previous_block.length)
                {
                    $previous_block.after($block_with_controls);
                }
                else
                {
                    $('.scene-block-list',$scene).prepend($block_with_controls);
                }

                get_block_klass_select_markup(function(html){
                    $block.hide();
                    $block.prepend(function(){
                        return build_this_klass_select(html, $block);
                    });
                    $block.slideDown();
                    activate_autogrow($('textarea', $block))
                });

                activate_attachment_sort($('.block-attachment-list', $block));
            }
        });
        return false;
    })

    .on('click','.add-attachment-btn', function(){
        var $block = $(this).parents('li.block');
        var $previous_attachment = $(this).parents('li').prev('.attachment');

        $.ajax({
            type: 'POST',
            url: '/attachments',
            dataType: 'html',
            data:
            {
                'attachment[block_id]': $block.data('block-id'),
                'previous_attachment': $previous_attachment.data('attachment-id')
            },
            error: error,
            success: function (html) {
                $attachment_with_controls = $(html);

                active_autogrow($('textarea', $attachment_with_controls));

                if ($previous_attachment.length)
                {
                    $previous_attachment.after($attachment_with_controls);
                }
                else
                {
                    $('.block-attachment-list',$block).prepend($attachment_with_controls);
                }
            }
        });
        return false;
    })

    //Delete Scene, Block, Attachment

    .on('click', '.delete-block-btn', function(){
        var $block = $(this).parents('li.block');

        $.ajax({
            type: 'DELETE',
            url: '/blocks/' + $block.data('block-id'),
            dataType: 'html',
            data: null,
            error: error,
            success: function (data) {
                $block.prev().slideUp('fast',function(){$(this).remove();});
                $block.slideUp('fast',function(){$(this).remove();});
            }
        });
        return false;
    })

    .on('click', '.delete-attachment-btn', function() {
        var $attachment = $(this).parents('li.attachment');

        $.ajax({
            type: 'DELETE',
            url: '/attachments/' + $attachment.data('attachment-id'),
            dataType: 'html',
            data: null,
            error: error,
            success: function (data) {
                $attachment.slideUp('fast',function(){
                    ensure_block_height($attachment.parents('.block-attachment-list'));
                    $attachment.remove();
                });

            }
        });
        return false;
    })

    .on('click', '.delete-scene-btn', function() {
        var $scene = $(this).parents('li.scene');

        $.ajax({
            type: 'DELETE',
            url: '/scenes/' + $scene.data('scene-id'),
            dataType: 'html',
            data: null,
            error: error,
            success: function () {
                $scene.prev().remove();
                $('li[data-scene-id="' + $scene.data('scene-id') + '"]', $toc).remove();

                $scene.slideUp('fast',function(){
                    $scene.remove();
                });

            }
        });
        return false;
    })

    // Post on Blur


    .on('focusout blur','input[data-post-url], textarea[data-post-url]',function() {
            data_post(this);
            if ($(this).hasClass('scene-title'))
            {
                update_toc(this);
            }
        })
    .on('focusout blur','div[contenteditable]',function() {
        data_post(this);
    })
    .on('change','select[data-post-url]',function() {
        data_post(this);
        change_class(this);
    });

    $('.story-description, .story-title')
        .on('focusout blur', function() {
            data_post(this);
        })

    //Audio/Video Attachments

    activate_jplayer_audio($(".audio-player"));
    activate_jplayer_video($(".video-player"));


    $story.on('hidden', '.video-modal', function(){
        $('.video-player').jPlayer('pause');
    });

    //Helper Functions

    function error(xhr)
    {
        alert(xhr.responseText);
    }

    function get_block_klass_select_markup(success)
    {
        $.ajax({
            type: 'GET',
            url: '/blocks/klass_select_markup/',
            dataType: 'html',
            data: null,
            error: error,
            success: success
        });
    }

    function populate_block_klass_selects (html)
    {
        $('div.column','.block').prepend(function(){
            return build_this_klass_select(html, $(this));
        });

        change_class($('select[name="block[klass]"]'));
    }

    function build_this_klass_select(html, $object)
    {
        if ($object.hasClass('block'))
        {
            $block = $object;
        }
        else
        {
            $block = $object.parents('.block');
        }

        $tpl = $(html);
        var block_klass = $block.attr('class').substring(0, $block.attr('class').indexOf(' '));
        $('option[value="' + block_klass + '"]', $tpl)
            .attr('selected', 'selected');

        $tpl
            .attr(
            'data-post-url',
            $tpl.attr('data-post-url')
                .replace(':block_id', $block.attr('data-block-id')) );

        return $tpl;
    }

    function ensure_block_height($attachment_list)
    {
        $block = $attachment_list.parents('.block');
        start_height = $block.height();
        $block.css('min-height','');

        if ($attachment_list.height() > $block.height())
        {
            $block.css('min-height', start_height);

            $block.animate({
                minHeight: $attachment_list.height() + 15
            }, 500);

        }
    }

    function autogrow_complete($textarea)
    {
        $textarea.height(Math.max($textarea.height(),24));
        ensure_block_height($textarea.parents('.block-attachment-list'));
    }

    function activate_autogrow($obj)
    {
        $obj.autogrow({
            complete: autogrow_complete,
            short: true
        });
    }

    function activate_wysiwyg($obj)
    {
        $obj.each(function(i, txt){
            build_editor($(txt));
        });
    }

    function build_editor($attach_to) {
        var $editor = WysiHat.Editor.attach($attach_to);

        var $toolbar = $('<div class="editor_toolbar"></div>');

        var $bold_button = $('<a href="#" class="bold"><i class="icon-bold"></i></a>');
        $bold_button.click(function(e) {
            $editor.boldSelection();
            return false;
        });
        var $italic_button = $('<a href="#" class="italic"><i class="icon-italic"></i></a>');
        $italic_button.click(function(e) {
            $editor.italicSelection();
            return false;
        });
        var $link_button = $('<a href="#" class="link"><i class="icon-link"></i></a>');
        $link_button.click(function(e) {
            if ($editor.linkSelected()) {
                if (confirm("Remove link?"))
                    $editor.unlinkSelection();
            } else {
                var value = prompt("Enter a URL", "http://www.google.com/");
                if (value)
                    $editor.linkSelection(value);
            }
            return false;
        });

        $toolbar
            .append($bold_button)
            .append($italic_button)
            .append($link_button);

        $editor.before($toolbar);

        $editor
            .bind('wysihat:cursormove', function(e) {
                if ($editor.boldSelected())
                    boldButton.addClass('selected');
                else
                    boldButton.removeClass('selected');
            })
            .bind('wysihat:cursormove', function(e) {
                if ($editor.underlineSelected())
                    underlineButton.addClassName('selected');
                else
                    underlineButton.removeClassName('selected');
            })
            .bind('wysihat:cursormove', function(e) {
                if ($editor.italicSelected())
                    italicButton.addClassName('selected');
                else
                    italicButton.removeClassName('selected');
            })
            .attr('name', $attach_to.attr('name'))
            .attr('data-post-url', $attach_to.attr('data-post-url'))
            .attr('data-dirty', $attach_to.attr('data-dirty'));
    }

    function activate_block_sort($obj)
    {
       $obj.sortable({
           axis: 'y',
           handle: '.sorting-handle',
           start: function (e, ui) {
               $add_link = $(ui.item).prev();
           },
           update: function(e, ui) {
               var $previous_block = $(ui.item).prev('.block');
                $.ajax({
                   type: 'PUT',
                   url: '/blocks/' + $(ui.item).data('block-id'),
                   dataType: 'html',
                   data: "previous_block=" + ($previous_block.data('block-id') || ''),
                   error: error,
                   success: function () {
                       $block = $(ui.item);
                       $prev_li = $block.prev();
                       //the list has blocks and add block links, both are lis
                       //this code ensures the block is being dropped in the right place
                       if (!$prev_li.hasClass('block'))
                       {
                           $prev_li.before($block);
                       }
                       $block.before($add_link);
                   }
               });
           }
       });
    }

    function activate_attachment_sort($obj)
    {
        $obj.sortable({
            axis: 'y',
            update: function(e, ui) {
                var $previous_attachment = $(ui.item).prev('.attachment');
                $.ajax({
                    type: 'PUT',
                    url: '/attachments/' + $(ui.item).data('attachment-id'),
                    dataType: 'html',
                    data: "previous_attachment=" + ($previous_attachment.data('attachment-id') || ''),
                    error: error,
                    success: function () {
                        $attachment = $(ui.item);
                        $prev_li = $attachment .prev();
                         if (!$prev_li.hasClass('attachment'))
                        {
                            $prev_li.before($attachment);
                        }
                    }
                });
            }
        });
    }

    function update_toc (title_object)
    {
        $title = $(title_object);
        $scene = $title.parents('.scene');
        $toc_link = $('a[href="#scene-'+ $scene.data('scene-id') + '"]', $('#toc'));
        $toc_link.text($title.val());
    }

    function change_class(object)
    {
        $(object).each(function(i, o){
            $sel = $(o);
            $block = $sel.parents('.block');
            $block.attr('class', $sel.val() + ' block');
            var $editorBody = $('iframe', $block).contents().find('body');
            $editorBody.attr('class', $sel.val());
        });
    }

    function data_post(object)
    {
        var dirty_value = null;
        var current_value = null;

        // get the original and current values based on input type -- used to determine if we are dirty
        switch (object.type) {
            case 'checkbox' :
                dirty_value = $(object).attr('data-dirty') == 'true' ? true : false;
                current_value = $(object).attr('checked') ? true : false;
                break;
            case undefined:
                dirty_value = $(object).attr('data-dirty');
                current_value = $(object).html();
                break;
            default :
                dirty_value = $(object).attr('data-dirty');
                current_value = $(object).val();
                break;
        }

        // If we are dirty do something, else ignore
        if (current_value != dirty_value) {
            // Get the target url and name
            var target_name = $(object).attr('name');

            // Get the object type (since this can be anything) and the key that's being changed
            var object_type = target_name.substr(0,target_name.indexOf('['));
            var object_key = target_name.substr(
                target_name.indexOf('[')+1,
                target_name.length - target_name.indexOf('[') - 2);

            // Turn that into a json data stack for PUT'ing to the server
            eval("var data = { " + object_type + " : { " + object_key + " : current_value } }");

            // Okay now do the put
            $.ajax({
                type: 'PUT',
                url: $(object).attr('data-post-url'),
                dataType: 'json',
                data: data,
                error: function(xhr) {
                    var err = '';
                    try { err = JSON.parse(xhr.responseText)[object_key][0]; }
                    catch(ex) { err = xhr.responseText; }
                    $(object)
                        .addClass('error')
                        .attr('title', err);
                },
                success: function () {
                    $(object)
                        .attr('data-dirty', current_value)
                        .removeClass('error')
                        .attr('title', '');
                }
            });
        }
    }

    function activate_jplayer_audio($obj)
    {
        $obj.each(function(i, object){

            $(object).jPlayer({
                ready: function () {
                    $(this).jPlayer("setMedia",
                        JSON.parse('{ "' + $(this).data('file-format') + '": "' + $(this).data('file-path') + '" }')
                    );
                },
                cssSelectorAncestor: "#jp-interface-" + $(object).parents('.attachment').data('attachment-id'),
                swfPath: "/assets",
                supplied: $(object).data('file-format'),
                wmode: "window"
            });

        });

    }

    function activate_jplayer_video($obj)
    {
        $obj.each(function(i, object){

            $(object).jPlayer({
                ready: function () {
                    var test = JSON.parse('{ "' + $(this).data('file-format') + '": "' + $(this).data('file-path') + '", "poster":"' + $(this).data('thumb-path') + '" }');

                    $(this).jPlayer("setMedia",
                        JSON.parse('{ "' + $(this).data('file-format') + '": "' + $(this).data('file-path') + '", "poster":"' + $(this).data('thumb-path') + '" }')
                    );
                },
                cssSelectorAncestor: "#jp_container_" + $(object).parents('.attachment').data('attachment-id'),
                swfPath: "/assets",
                supplied: $(object).data('file-format'),
                size: {
                    width: $(object).data('video-width') + "px",
                    height: $(object).data('video-height') + "px",
                    cssClass: "jp-video-480p"
                }

            });

        });

    }

});