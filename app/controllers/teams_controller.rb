class TeamsController < ApplicationController
  
  before_filter :require_login
  
  def new
  end
  
  def show
    @team = Team.find(params[:id])
    @players = @team.players
  end
  
  def create
    params.permit(:name)
    new_team = Team.new
    new_team.name = params[:name]
    league = League.find(params[:league_id])
    
    if league.team_name_available?(new_team.name)
      new_team.league = league
      new_team.user = @user
      league.save
      new_team.save
    
      redirect_to league_team_path(league, new_team)
    else
      flash[:'alert-error'] = "Team name is already taken"
      redirect_to league_path(league)
    end
  end
  
  def update
  end
  
  def destroy
  end
  
end
