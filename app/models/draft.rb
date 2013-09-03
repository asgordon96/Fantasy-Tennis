class Draft < ActiveRecord::Base
  belongs_to :league
  belongs_to :current_team, :class_name => 'Team', :foreign_key => :current_team_id
  belongs_to :nominator, :class_name => 'Team', :foreign_key => :nominator
  
  def get_next_nominator
    team_order = Team.teams_from_ids(self.order)
    index = team_order.index(self.nominator)
    while true
      if index == team_order.length - 1
        index = 0
      else
        index += 1
      end
      team = team_order[index]
      unless team.full?
        self.nominator = team
        return self.nominator
      end
    end
  end
  
end
