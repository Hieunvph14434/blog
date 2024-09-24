class AddCoverImgUrlToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :cover_img_url, :string
  end
end
