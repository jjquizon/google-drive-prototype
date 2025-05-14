require "google/apis/drive_v3"
require "googleauth"

module GoogleDriveConfig
  class << self
    def drive_service
      @drive_service ||= Google::Apis::DriveV3::DriveService.new.tap do |service|
        service.authorization = authorize
      end
    end

    private

    def authorize
      Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(credentials_path),
        scope: Google::Apis::DriveV3::AUTH_DRIVE
      )
    end

    def credentials_path
      Rails.root.join("config", "google_drive_key.json")
    end
  end
end
