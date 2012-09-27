class StoryDecorator < ApplicationDecorator
  decorates :story
  decorates_association :scenes

  def table_of_contents
    h.render :partial => 'stories/table_of_contents', :locals => { story: model }
  end

end
