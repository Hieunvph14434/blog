class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :author,  null: false, foreign_key: { to_table: :users } # Sử dụng references để tạo cột author_id
      t.string :title,       null: false
      t.text :content,       null: false
      t.string :cover_image, null: true, default: nil
      t.integer :status,     null: false, default: 0 # 0: Draft, 1: Published
      t.timestamps
    end
  end
end
