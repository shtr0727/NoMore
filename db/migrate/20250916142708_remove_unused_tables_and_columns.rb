class RemoveUnusedTablesAndColumns < ActiveRecord::Migration[7.1]
  def change
    # post_badgesテーブルを削除（バッジ機能は動的計算に変更済み）
    drop_table :post_badges do |t|
      t.integer :post_id, null: false
      t.integer :badge_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:badge_id], name: "index_post_badges_on_badge_id"
      t.index [:post_id], name: "index_post_badges_on_post_id"
    end
    
    # usersテーブルからprofile_image_idカラムを削除（Active Storageに移行済み）
    remove_column :users, :profile_image_id, :integer
    
    # relationshipsテーブルに外部キー制約を追加
    add_foreign_key :relationships, :users, column: :follower_id
    add_foreign_key :relationships, :users, column: :followed_id
  end
end
