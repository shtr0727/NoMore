class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :post
      t.text :reason
      t.references :category, null: false, foreign_key: true
      t.references :streak, null: false, foreign_key: true
      t.boolean :is_draft
      t.datetime :recorded_on

      t.timestamps
    end
  end
end
