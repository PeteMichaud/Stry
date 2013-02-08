class StoryDecorator < ApplicationDecorator
  decorates :story
  decorates_association :scenes

  def table_of_contents
    h.render :partial => 'editor/stories/table_of_contents', :locals => { story: model }
  end

  def title
    return model.title unless model.title.blank?
    "[Untitled]"
  end

end
