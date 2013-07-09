class Team < ActiveRecord::Base
  has_and_belongs_to_many :players
  belongs_to :league
  
  validates :name, :presence => true
  
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
