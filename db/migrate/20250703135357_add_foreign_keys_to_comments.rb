class AddForeignKeysToComments < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :comments, :users
    add_foreign_key :comments, :posts
  end
end
