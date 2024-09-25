class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :comments, dependent: :destroy
  enum status: { draft: 0, published: 1 }
  LIMIT_RECENT_POSTS = 5
  
  validates :title, :content, presence: true, on: :create

  def status=(value)
    super(value.to_i)
  end

  # Specify the associations that can be searched
  def self.ransackable_associations(auth_object = nil)
    ["author"]
  end

  # Make sure you also define ransackable_attributes if needed
  def self.ransackable_attributes(auth_object = nil)
    %w[title content]
  end

  # Method to get the thumbnail URL dynamically
  def thumbnail
    @thumbnail_url
  end

  # Method to set the thumbnail URL dynamically
  def thumbnail=(url)
    @thumbnail_url = url
  end
end
