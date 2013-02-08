class AttachmentDecorator < ApplicationDecorator
  decorates :attachment

  def render
    if model.is_image?
      h.render :partial => 'editor/attachments/types/image', :locals => { :attachment => self }
    elsif model.is_audio?
      h.render :partial => 'editor/attachments/types/audio', :locals => { :attachment => self }
    elsif model.is_video?
      h.render :partial => 'editor/attachments/types/video', :locals => { :attachment => self }
    else
      h.render :partial => 'editor/attachments/types/file', :locals => { :attachment => self }
    end
  end
end
