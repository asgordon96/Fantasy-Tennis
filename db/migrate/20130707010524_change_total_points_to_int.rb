class ChangeTotalPointsToInt < ActiveRecord::Migration
  def change
    remove_column :teams, :total_points
    add_column :teams, :total_points, :integer
  end
end
