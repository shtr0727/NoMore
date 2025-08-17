class ChangeRecordedOnToDateInPosts < ActiveRecord::Migration[7.1]
  def change
    change_column :posts, :recorded_on, :date
  end
end
