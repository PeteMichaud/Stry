class Attachment < ActiveRecord::Base
  attr_accessible :file, :caption, :sequence, :block_id
  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :block

  validates :block, :presence => true
  validates :file, :attachment_presence => true

  def is_image?
    is_type? %w(jpg jpeg gif png tif tiff bmp)
  end

  def is_audio?
    is_type? %w(mp3 m4a wav)
  end

  def is_video?
    is_type? %w(mpg mpeg avi flv mov mp4 wmv)
  end

  private

  def is_type? legal
    legal.include? File.extname(file.path)[1..4] unless file.path.nil?
  end

end
