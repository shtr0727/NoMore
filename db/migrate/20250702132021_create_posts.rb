class RemoveStreakIdFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_reference :posts, :streak, foreign_key: true
  end
end
