class AddNumTeamsAndNumPlayersToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :num_teams, :integer
    add_column :leagues, :players_per_team, :integer
  end
end
