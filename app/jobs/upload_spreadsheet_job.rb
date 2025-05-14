class UploadSpreadsheetJob < ApplicationJob
  queue_as :default

  def perform(spreadsheet_id, temp_file_path)
    spreadsheet = Spreadsheet.find(spreadsheet_id)

    begin
      service = GoogleDriveService.new
      file_id = service.upload_file(temp_file_path, spreadsheet.original_filename)

      spreadsheet.update!(google_drive_file_id: file_id)
    rescue => e
      Rails.logger.error "Failed to upload spreadsheet #{spreadsheet_id}: #{e.message}"
      spreadsheet.destroy # Clean up the record if upload fails
      raise e # Re-raise the error to trigger job retry
    ensure
      # Clean up temporary file
      File.delete(temp_file_path) if File.exist?(temp_file_path)
    end
  end

  retry_on StandardError, wait: :exponentially_longer, attempts: 3
end
