class DropNotTodos < ActiveRecord::Migration[7.0]
  def change
    drop_table :not_todos
  end
end
