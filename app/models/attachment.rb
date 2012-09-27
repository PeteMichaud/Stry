class Attachment < ActiveRecord::Base
  attr_accessible :file, :caption, :sequence, :block_id
  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :block

  validates :block, :presence => true
  validates :file, :attachment_presence => true

  #Presents the file in html based on it's file type
  def present
    if is_image?
      render :partial => 'attachments/types/image', :locals => { :image => file }
    elsif is_audio?
      render :partial => 'attachments/types/audio', :locals => { :sound => file }
    elsif is_video?
      render :partial => 'attachments/types/video', :locals => { :video => file }
    else
      render :partial => 'attachments/types/generic', :locals => { :file => file }
    end

  end

  def is_image?
    is_type? %w(jpg jpeg gif png tif tiff bmp)
  end

  def is_audio?
    is_type? %w(mp3 m4a wav)
  end

  def is_video?
    is_type? %w(mpg mpeg avi flv mov mp4 wmv)
  end

  def is_type? legal
    legal.include? File.extname(file.path)[1..4]
  end

end
