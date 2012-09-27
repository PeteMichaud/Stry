class Block < ActiveRecord::Base
  include Sequential
  attr_accessible :klass, :content, :sequence, :scene_id

  belongs_to :scene
  has_many :attachments, :order => "sequence ASC", :dependent => :destroy

  def insert attachment, after_id = nil
    insert_object attachments, attachment, after_id
  end

  def remove attachment
    remove_object attachments, attachment
  end

end
