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

  def image_dimensions style = :original
    return nil unless is_image?
    Paperclip::Geometry.from_file(file.path(style)) unless file.path(style).blank?
  end

  def video_meta style = :original
    return nil unless is_video?
    meta = {}
    ffmpeg = IO.popen("ffmpeg -i \"#{File.expand_path(file.path(style))}\" 2>&1")
    ffmpeg.each("\r") do |line|
      if line =~ /((\d*)\s.?)fps,/
        meta[:fps] = $1.to_i
      end
      # Matching lines like:
      # Video: h264, yuvj420p, 640x480 [PAR 72:72 DAR 4:3], 10301 kb/s, 30 fps, 30 tbr, 600 tbn, 600 tbc
      if line =~ /Video:(.*)/
        v = $1.to_s.split(',')
        size = v[2].strip!.split(' ').first
        meta[:size] = size.to_s
        meta[:width], meta[:height] = size.split('x')
        meta[:aspect] = meta[:width].to_f / meta[:height].to_f
      end
      # Matching Duration: 00:01:31.66, start: 0.000000, bitrate: 10404 kb/s
      if line =~ /Duration:(\s.?(\d*):(\d*):(\d*\.\d*))/
        meta[:length] = $2.to_s + ":" + $3.to_s + ":" + $4.to_s
      end
    end
    meta
  end

  private

  def is_type? legal, type = nil
    type = type.present? ? type.split('/')[-1] : File.extname(file.path||'')[1..-1]
    legal.include? type
  end

end
