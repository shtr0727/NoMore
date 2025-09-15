class AddFieldsToBadges < ActiveRecord::Migration[7.1]
  def change
    add_column :badges, :badge_type, :string
    add_column :badges, :required_days, :integer
  end
end
