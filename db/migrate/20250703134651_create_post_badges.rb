class CreatePostBadges < ActiveRecord::Migration[7.1]
  def change
    create_table :post_badges do |t|
      t.references :post, null: false, foreign_key: true
      t.references :badge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
