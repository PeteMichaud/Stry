class Story < ActiveRecord::Base
  include Sequential
  attr_accessible :title, :description, :author_id

  has_many :scenes, :order => "sequence ASC", :dependent => :destroy
  belongs_to :author, :class_name => User

  validates :author, :presence => true

  def insert scene, after_id = nil
    insert_object scenes, scene, after_id
  end

  def remove scene
    remove_object scenes, scene
  end

end
