class AttachmentDecorator < ApplicationDecorator
  decorates :attachment

  def render
    if model.is_image?
      h.render :partial => 'attachments/types/image', :locals => { :image => file }
    elsif model.is_audio?
      h.render :partial => 'attachments/types/audio', :locals => { :attachment => self }
    elsif model.is_video?
      h.render :partial => 'attachments/types/video', :locals => { :attachment => self }
    else
      h.render :partial => 'attachments/types/generic', :locals => { :file => file }
    end
  end
end
