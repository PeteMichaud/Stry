class StoryDecorator < Draper::Base
  decorates :story
  decorates_association :scenes

  def table_of_contents
    h.render :partial => 'stories/table_of_contents', :locals => { story: model }
  end

  def editable field
    h.render :partial => 'shared/editable_field', :locals => {
        type: 'story',
        prop: field.to_s,
        object: self
    }
  end

end
