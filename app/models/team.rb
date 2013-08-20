class Team < ActiveRecord::Base
  has_and_belongs_to_many :players
  belongs_to :league
  belongs_to :user
  
  validates :name, :presence => true
  
  def self.teams_from_ids(id_string)
    team_ids = id_string.split(',').map { |id| id.to_i }
    Team.find(team_ids)
  end
  
  def add_points(points)
    self.total_points += points
    self.save
  end
  
  def add_player_by_id(player_id)
    self.players << Player.find(player_id)
  end
  
  def add_player_by_name(player_name)
    new_player = Player.find_by_name(player_name)
    if new_player
      self.players << new_player
    end
  end
end
