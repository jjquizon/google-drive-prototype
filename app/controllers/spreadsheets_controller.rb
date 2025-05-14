class SpreadsheetsController < ApplicationController
  def index
    @spreadsheets = current_user.spreadsheets.order(created_at: :desc)
  end

  def new
    @spreadsheet = current_user.spreadsheets.build
  end

  def create
    @spreadsheet = current_user.spreadsheets.build
    uploaded_file = params[:spreadsheet][:file]

    if uploaded_file.present?
      @spreadsheet.original_filename = uploaded_file.original_filename

      # Create a temporary file to store the upload
      temp_file = Tempfile.new([ "upload", ".xlsx" ])
      temp_file.binmode
      temp_file.write(uploaded_file.read)
      temp_file.close

      if @spreadsheet.save
        # Enqueue the upload job
        UploadSpreadsheetJob.perform_later(@spreadsheet.id, temp_file.path)
        redirect_to spreadsheets_path, notice: "Spreadsheet is being processed"
      else
        # Clean up temp file if save fails
        File.delete(temp_file.path)
        render :new, status: :unprocessable_entity
      end
    else
      @spreadsheet.errors.add(:file, "must be selected")
      render :new, status: :unprocessable_entity
    end
  end

  def share
    @spreadsheet = current_user.spreadsheets.find(params[:id])

    if @spreadsheet.google_drive_file_id.present?
      CreateSpreadsheetShareJob.perform_later(@spreadsheet.id)
      redirect_to spreadsheets_path, notice: "Share link is being generated"
    else
      redirect_to spreadsheets_path, alert: "Spreadsheet is still being processed"
    end
  end

  private

  def spreadsheet_params
    params.require(:spreadsheet).permit(:file)
  end
end
