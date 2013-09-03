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
  
  def get_place
    standings = self.league.teams.order("total_points DESC").pluck(:total_points)
    place = standings.index(self.total_points) + 1
    tied = standings[place] == self.total_points
    tied_text = tied ? "Tied " : ""
    "#{tied_text}#{place.ordinalize} Place"
  end
  
  def full?
    self.players.length == self.league.players_per_team
  end
  
end
