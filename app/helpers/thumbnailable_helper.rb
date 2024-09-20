module ThumbnailableHelper
    # Load image URL
    def load_thumbnails(posts, show_no_image = false, type = nil)
      service = GoogleDriveService.new
      file_ids = posts.map do |post|
        post.cover_image if post.cover_image.present? && (show_no_image || post.cover_image != ENV['NO_IMAGE'])
      end.compact
  
      # Fetch thumbnails
      thumbnails = service.get_thumbnails(file_ids)
  
      # Assign thumbnails to each post based on cover_image
      posts.each do |post|
        if post.cover_image.present? && thumbnails[post.cover_image]
          post.thumbnail = thumbnails[post.cover_image]
        end
      end
  
      # Assign to @thumbnails or @thumbnailsDetail based on the value of type
      if type == 'show'
        @thumbnailsDetail = posts.map(&:thumbnail)
      else
        @thumbnails = posts.map(&:thumbnail)
      end
    end
end
