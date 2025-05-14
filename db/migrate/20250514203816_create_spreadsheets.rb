class CreateSpreadsheets < ActiveRecord::Migration[7.1]
  def change
    create_table :spreadsheets do |t|
      t.string :original_filename, null: false
      t.string :google_drive_file_id, null: false
      t.string :copy_file_id
      t.string :share_link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :spreadsheets, :google_drive_file_id, unique: true
  end
end
