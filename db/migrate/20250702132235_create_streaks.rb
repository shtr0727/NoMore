class CreateStreaks < ActiveRecord::Migration[7.1]
  def change
    create_table :streaks do |t|
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
