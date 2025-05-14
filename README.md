# Google Drive Spreadsheet Portal

A Ruby on Rails application that allows users to upload Excel spreadsheets (.xlsx files), automatically stores them in Google Drive, creates shareable copies, and manages sharing permissions.

## Prerequisites

- Ruby 3.x
- Rails 7.x
- PostgreSQL
- Node.js and Yarn
- Google Cloud Platform account with Drive API enabled

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd google-drive-prototype
```

2. Install dependencies:
```bash
bundle install
yarn install
```

3. Configure Google Drive credentials:
   - Create a service account in Google Cloud Console
   - Download the credentials JSON file
   - Rename it to `service-account.json`
   - Place it in `config/credentials/`
   - Create two folders in your Google Drive:
     - One for original file uploads
     - One for shared copies
   - Share both folders with the service account email

4. Set up environment variables:
   Create a `.env` file in the root directory with:
```
GOOGLE_DRIVE_UPLOAD_FOLDER_ID=your_upload_folder_id
GOOGLE_DRIVE_SHARED_FOLDER_ID=your_shared_folder_id
```

5. Database setup:
```bash
rails db:create
rails db:migrate
```

## Running the Application

1. Start the Rails server:
```bash
rails server
```

2. Start the asset compilation (in a separate terminal):
```bash
yarn build --watch
```

3. For production deployment, precompile assets:
```bash
rails assets:precompile
```

4. Visit `http://localhost:3000` in your browser

## Features

- User authentication system
- Excel (.xlsx) file upload
- Automatic Google Drive storage
- Shareable spreadsheet copies
- Background job processing for file handling

## File Upload Rules

- Only .xlsx files are accepted
- Files are processed asynchronously
- Original files and copies are stored in separate Google Drive folders
- Share links are generated automatically

## Security Notes

- Keep your `service-account.json` secure and never commit it to version control
- Environment variables should be properly set for production deployment
- Regular security updates are recommended

## Troubleshooting

If you encounter issues:

1. Check Google Drive API is enabled and credentials are correct
2. Ensure proper folder permissions for the service account
3. Verify all environment variables are set
4. Check Rails logs for detailed error messages

## Development

To run the test suite:
```bash
rails test
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
