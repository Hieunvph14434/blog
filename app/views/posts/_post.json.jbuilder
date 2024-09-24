json.extract! post, :id, :title, :content, :cover_image, :status, :author_id, :created_at, :updated_at
json.url post_url(post, format: :json)
