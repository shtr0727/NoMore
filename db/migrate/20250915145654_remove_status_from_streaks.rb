class RemoveStatusFromStreaks < ActiveRecord::Migration[7.1]
  def change
    remove_column :streaks, :status, :string
  end
end
