class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.string      :title
      t.text        :notes
      t.integer     :narrative_intensity, :default => 0, :limit => 1 #127
      t.integer     :gameplay_intensity,  :default => 0, :limit => 1
      t.integer     :sequence,            :default => 0, :limit => 2 #32768
      t.references :story
      t.timestamps
    end
  end
end
