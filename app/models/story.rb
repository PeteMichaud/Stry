class Story < ActiveRecord::Base
  include Sequential
  attr_accessible :title, :description, :author_id, :author

  has_many :scenes, :order => "sequence ASC", :dependent => :destroy
  belongs_to :author, :class_name => User

  validates :author, :presence => true

  def insert scene, after_id = nil
    insert_object scenes.scoped, scene, after_id
  end

  def remove scene
    remove_object scenes, scene
  end

  def self.new_blank_by author
    story = Story.create({title: '', author: author})

    story.insert Scene.new
    story.scenes.first.insert Block.new

    story.save!

    story
  end

end
