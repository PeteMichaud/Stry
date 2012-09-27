class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string      :title,
      t.text        :description
      t.integer     :author_id,   :null => false, :unsigned => true
      t.timestamps
    end
  end
end
