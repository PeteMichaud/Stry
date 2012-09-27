class Paperclip::Attachment
  def file_type
    return File.extname(self.path)[1..-1] if self.path.present?
    nil
  end

  def file_name
    File.basename(self.path)
  end

  def pretty_name
    file_name.chomp(File.extname(file_name)).titleize
  end

end
