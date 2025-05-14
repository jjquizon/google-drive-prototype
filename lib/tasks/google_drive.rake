namespace :google_drive do
  desc "Verify Google Drive folder access and permissions"
  task verify_folders: :environment do
    $stdout.sync = true
    begin
      service = GoogleDriveService.new
      upload_folder_id = ENV.fetch("GOOGLE_DRIVE_UPLOAD_FOLDER_ID")
      shared_folder_id = ENV.fetch("GOOGLE_DRIVE_SHARED_FOLDER_ID")

      STDOUT.puts "\nChecking Google Drive configuration..."
      STDOUT.puts "=====================================\n\n"

      # Check upload folder
      STDOUT.puts "Checking upload folder (#{upload_folder_id})..."
      begin
        upload_folder = service.instance_variable_get(:@service)
                              .get_file(upload_folder_id, fields: "name, permissions")
        STDOUT.puts "✅ Upload folder found: #{upload_folder.name}"

        if upload_folder.permissions.any? { |p| p.role == "writer" || p.role == "owner" }
          STDOUT.puts "✅ Upload folder has write permissions"
        else
          STDOUT.puts "❌ Upload folder missing write permissions"
        end
      rescue Google::Apis::ClientError => e
        STDOUT.puts "❌ Error accessing upload folder: #{e.message}"
      end

      STDOUT.puts "\n"

      # Check shared folder
      STDOUT.puts "Checking shared folder (#{shared_folder_id})..."
      begin
        shared_folder = service.instance_variable_get(:@service)
                              .get_file(shared_folder_id, fields: "name, permissions")
        STDOUT.puts "✅ Shared folder found: #{shared_folder.name}"

        if shared_folder.permissions.any? { |p| p.role == "writer" || p.role == "owner" }
          STDOUT.puts "✅ Shared folder has write permissions"
        else
          STDOUT.puts "❌ Shared folder missing write permissions"
        end
      rescue Google::Apis::ClientError => e
        STDOUT.puts "❌ Error accessing shared folder: #{e.message}"
      end

      STDOUT.puts "\nDone!"
    rescue KeyError => e
      STDOUT.puts "❌ Missing environment variable: #{e.message}"
    rescue StandardError => e
      STDOUT.puts "❌ Error: #{e.message}"
    end
  end

  desc "Test file upload to Google Drive"
  task test_upload: :environment do
    $stdout.sync = true
    begin
      STDOUT.puts "\nTesting file upload to Google Drive..."
      STDOUT.puts "===================================\n\n"

      # Create a test file
      require "tempfile"
      test_file = Tempfile.new([ "test", ".xlsx" ])
      test_file.write("Test content")
      test_file.close

      service = GoogleDriveService.new
      file_id = service.upload_file(test_file.path, "test_upload.xlsx")

      STDOUT.puts "✅ Successfully uploaded test file"
      STDOUT.puts "File ID: #{file_id}"

      # Test creating a shared copy
      result = service.create_shared_copy(file_id, "test_upload.xlsx")
      STDOUT.puts "\n✅ Successfully created shared copy"
      STDOUT.puts "Copy File ID: #{result[:file_id]}"
      STDOUT.puts "Share Link: #{result[:share_link]}"

      STDOUT.puts "\nDone!"
    rescue StandardError => e
      STDOUT.puts "❌ Error: #{e.message}"
    ensure
      test_file.unlink if test_file
    end
  end
end
