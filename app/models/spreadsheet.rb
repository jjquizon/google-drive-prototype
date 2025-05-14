class Spreadsheet < ApplicationRecord
  belongs_to :user

  validates :original_filename, presence: true
  validates :google_drive_file_id, uniqueness: true, allow_nil: true

  # Optional fields that will be set after Google Drive operations
  validates :copy_file_id, uniqueness: true, allow_nil: true
  validates :share_link, presence: true, allow_nil: true

  # Validate file extension
  validate :file_extension_is_xlsx

  # Virtual attribute for file upload
  attr_accessor :file

  def processing?
    google_drive_file_id.nil?
  end

  def sharing?
    google_drive_file_id.present? && share_link.nil?
  end

  private

  def file_extension_is_xlsx
    return if original_filename.blank?

    unless original_filename.downcase.end_with?(".xlsx")
      errors.add(:original_filename, "must be an XLSX file")
    end
  end
end
