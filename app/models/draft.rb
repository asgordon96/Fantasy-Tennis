class Draft < ActiveRecord::Base
  belongs_to :league
  belongs_to :current_team, :class_name => 'Team', :foreign_key => :current_team_id
  belongs_to :nominator, :class_name => 'Team', :foreign_key => :nominator
end
