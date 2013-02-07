class Scene < ActiveRecord::Base
  include Sequential
  attr_accessible :title, :notes, :narrative_intensity, :gameplay_intensity, :sequence, :story_id

  has_many :blocks, :order => "sequence ASC", :dependent => :destroy
  belongs_to :story

  validates :story, :presence => true

  def insert block, after_id = nil
    insert_object blocks.scoped, block, after_id
  end

  def remove block
    remove_object blocks, block
  end

end
