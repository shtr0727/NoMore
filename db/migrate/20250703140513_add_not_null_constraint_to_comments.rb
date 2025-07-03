class AddNotNullConstraintToComments < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comments, :user_id, false
    change_column_null :comments, :post_id, false
  end
end
