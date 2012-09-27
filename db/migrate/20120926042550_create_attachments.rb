class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.has_attached_file  :file
      t.text        :caption
      t.integer     :sequence, :default => 0, :limit => 1
      t.references  :block
      t.timestamps
    end
  end
end
