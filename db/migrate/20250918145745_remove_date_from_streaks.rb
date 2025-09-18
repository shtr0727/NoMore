class RemoveDateFromStreaks < ActiveRecord::Migration[7.1]
  def change
    remove_column :streaks, :date, :date
  end
end
