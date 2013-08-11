class League < ActiveRecord::Base
  has_many :teams
  validates :name, :presence => true, :uniqueness => true
  validate :future_draft_date
  
  def set_draft_time(date, time)
    self.draft_time = "#{date} #{time}"
  end
  
  def get_standings
    self.teams.order("total_points DESC")
  end
  
  def has_user?(user)
    team = self.teams.where(:user_id => user.id)
    if team.empty?
      false
    else
      team.first
    end
  end
  
  def team_name_available?(team_name)
    if self.teams.where(:name => team_name).empty?
      true
    else
      false
    end
  end
  
  # make sure the draft date is in the future
  def future_draft_date
    if self.draft_time.past?
      errors.add(:draft_time, "must be in the future")
    end
  end
  
  # return players not on any teams
  def available_players
    owned_player_ids = self.teams.map { |team| team.players.pluck(:id) }.flatten
    if owned_player_ids.blank?
      Player.all.order("rank")
    else
      Player.where("id NOT IN (?)", owned_player_ids).order("rank")
    end
  end
  
  def team_for_user(user)
    Team.where(:user_id => user.id, :league_id => self.id).first
  end
    
end
