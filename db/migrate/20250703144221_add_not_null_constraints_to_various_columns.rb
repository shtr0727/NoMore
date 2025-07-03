class AddNotNullConstraintsToVariousColumns < ActiveRecord::Migration[7.1]
  def change
    change_column_null :badges, :name, false
    change_column_null :badges, :description, false
    change_column_null :categories, :name, false
    change_column_null :comments, :content, false
    change_column_null :posts, :post, false
    change_column_null :posts, :reason, false
    change_column_null :posts, :is_draft, false
    change_column_null :posts, :recorded_on, false
    change_column_null :streaks, :date, false
    change_column_null :streaks, :status, false
    change_column_null :users, :name, false
    change_column_null :users, :email, false
    change_column_null :users, :encrypted_password, false
  end
end
