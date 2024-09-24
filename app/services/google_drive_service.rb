require 'google/apis/drive_v3'
require 'googleauth'

class GoogleDriveService
  APPLICATION_NAME = 'Google Drive API Blog Rails'
  SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_FILE

  def initialize
    @service = Google::Apis::DriveV3::DriveService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def upload_file(file_path, file_name, mime_type)
    folder_id = find_or_create_folder(ENV['GOOGLE_DRIVE_FOLDER_ID'])
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    file_name_with_timestamp = "#{timestamp}_#{File.basename(file_name)}"
    file_metadata = {
      name: file_name_with_timestamp,
      parents: [folder_id]
    }

    file = @service.create_file(
      file_metadata,
      upload_source: file_path,
      content_type: mime_type,
      fields: 'id, thumbnailLink'
    )
    {
      id: file.id,
      url: file.thumbnail_link
    }
  end

  def get_thumbnails(file_ids)
    results = Parallel.map(file_ids, in_threads: 5) do |file_id|
      begin
        file = @service.get_file(file_id, fields: 'thumbnailLink')
        [file_id, file.thumbnail_link] if file.thumbnail_link.present?
      rescue Google::Apis::ClientError => e
        puts "An error occurred for file_id #{file_id}: #{e.message}"
        nil
      end
    end

    results.compact.to_h # Convert the array of pairs to a hash
  end

  private

  def authorize
    client_id = ENV['GOOGLE_CLIENT_ID']
    client_secret = ENV['GOOGLE_CLIENT_SECRET']
    refresh_token = ENV['GOOGLE_REFRESH_TOKEN']

    Google::Auth::UserRefreshCredentials.new(
      client_id: client_id,
      client_secret: client_secret,
      scope: SCOPE,
      refresh_token: refresh_token
    )
  end

  def find_or_create_folder(folder_name)
    folder_id = find_folder_id(folder_name)
    
    if folder_id.nil?
      folder_metadata = {
        name: folder_name,
        mime_type: 'application/vnd.google-apps.folder'
      }
      folder = @service.create_file(folder_metadata, fields: 'id')
      folder.id
    else
      folder_id
    end
  end

  def find_folder_id(folder_name)
    response = @service.list_files(q: "name='#{folder_name}' and mimeType='application/vnd.google-apps.folder'", fields: 'files(id, name)')
    response.files.empty? ? nil : response.files.first.id
  end
end
