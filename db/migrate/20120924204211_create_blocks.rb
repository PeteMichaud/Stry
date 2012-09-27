class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.enum :klass, :limit => [:notes, :playable, :scripted, :cut_scene], :null => false, :default => :notes
      t.text :content
      t.integer :sequence, :default => 0, :limit => 2
      t.references :scene
      t.timestamps
    end
  end
end
