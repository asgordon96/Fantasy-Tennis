class AddPlayersTeamsRelation < ActiveRecord::Migration
  def change
    create_table :players_teams do |t|
      t.belongs_to :player
      t.belongs_to :team
    end
  end
end
