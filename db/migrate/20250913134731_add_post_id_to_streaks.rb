class AddPostIdToStreaks < ActiveRecord::Migration[7.1]
  def change
    # まず既存のstreaksデータをクリア
    Streak.delete_all
    
    # その後post_idカラムを追加
    add_reference :streaks, :post, null: false, foreign_key: true
  end
end
