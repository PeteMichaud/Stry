class Attachment < ActiveRecord::Base
  attr_accessible :file, :caption, :sequence, :block_id
  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :block

end
