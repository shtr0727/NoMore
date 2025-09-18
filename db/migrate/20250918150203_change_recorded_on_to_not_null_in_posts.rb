class ChangeRecordedOnToNotNullInPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :posts, :recorded_on, false
  end
end
