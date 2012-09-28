class Attachment < ActiveRecord::Base
  attr_accessible :file, :caption, :sequence, :block_id

  has_attached_file :file,
    :styles => Proc.new {
      |file| file.instance.file_styles
    },
    :processors => Proc.new {
      |attachment| attachment.file_processors
    }

  belongs_to :block

  validates :block, :presence => true
  validates :file, :attachment_presence => true

  def is_image? type = nil
    is_type? %w(jpg jpeg gif png tif tiff bmp), type
  end

  def is_audio? type = nil
    is_type? %w(mp3 m4a wav), type
  end

  def is_video? type = nil
    is_type? %w(mpg mpeg avi flv mov mp4 wmv m4v), type
  end

  #Gets paperclip processors based on file type
  def file_processors
    if is_video? file_content_type
      [:ffmpeg]
    elsif is_image? file_content_type
      [:thumbnail]
    end
  end

  #Gets paperclip styles based on file type
  def file_styles
    if is_image? file_content_type
      {
          :medium => "300x300>"
      }
    elsif is_video? file_content_type
      {
          :original => { :geometry => "640x480>", :format => 'm4v' },
          :thumb => { :geometry => "300x300>", :format => 'jpg', :time => 10 }
      }
    else
      { }
    end
  end

  private

  def is_type? legal, type = nil
    type = type.present? ? type.split('/')[-1] : File.extname(file.path||'')[1..-1]
    legal.include? type
  end

end
