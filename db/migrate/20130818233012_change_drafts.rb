class ChangeDrafts < ActiveRecord::Migration
  def change
    remove_column :drafts, :team
    add_column :drafts, :current_team_id, :integer
  end
end
