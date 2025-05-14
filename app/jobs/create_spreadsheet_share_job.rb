class CreateSpreadsheetShareJob < ApplicationJob
  queue_as :default

  def perform(spreadsheet_id)
    spreadsheet = Spreadsheet.find(spreadsheet_id)
    return if spreadsheet.share_link.present? # Already processed

    begin
      service = GoogleDriveService.new
      result = service.create_shared_copy(
        spreadsheet.google_drive_file_id,
        spreadsheet.original_filename
      )

      spreadsheet.update!(
        copy_file_id: result[:file_id],
        share_link: result[:share_link]
      )
    rescue => e
      Rails.logger.error "Failed to create share link for spreadsheet #{spreadsheet_id}: #{e.message}"
      raise e # Re-raise the error to trigger job retry
    end
  end

  retry_on StandardError, wait: :exponentially_longer, attempts: 3
end
