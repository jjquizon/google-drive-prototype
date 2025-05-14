class AllowNullGoogleDriveFileId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :spreadsheets, :google_drive_file_id, true
  end
end
