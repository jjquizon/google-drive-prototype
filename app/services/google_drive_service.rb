class GoogleDriveService
  def initialize
    @service = GoogleDriveConfig.drive_service
  end

  def upload_file(file_path, filename)
    file_metadata = {
      name: filename,
      parents: [ upload_folder_id ]
    }

    file = @service.create_file(
      file_metadata,
      upload_source: file_path,
      content_type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    file.id
  end

  def create_shared_copy(file_id, filename)
    # Create a copy in the shared folder
    copied_file = @service.copy_file(
      file_id,
      { name: "Copy of #{filename}", parents: [ shared_folder_id ] },
      fields: "id, webViewLink"
    )

    # Update sharing permissions to anyone with link can view
    permission = {
      type: "anyone",
      role: "reader",
      allowFileDiscovery: false
    }

    @service.create_permission(copied_file.id, permission)

    {
      file_id: copied_file.id,
      share_link: copied_file.web_view_link
    }
  end

  private

  def upload_folder_id
    ENV.fetch("GOOGLE_DRIVE_UPLOAD_FOLDER_ID")
  end

  def shared_folder_id
    ENV.fetch("GOOGLE_DRIVE_SHARED_FOLDER_ID")
  end
end
