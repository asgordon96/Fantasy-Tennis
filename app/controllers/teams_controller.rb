class TeamsController < ApplicationController
  
  before_filter :require_login
  
  def new
  end
  
  def show
    @team = Team.find(params[:id])
    
    if @team.user != @user
      raise ActionController::RoutingError, "Page not found"
    end
    
    @players = @team.players.order("rank ASC")
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
  
  # ajax call to drop a player
  def drop
    @team = Team.find(params[:id])
    player = Player.find(params[:player_id])
    @team.players.destroy(player)
    render :json => {}
  end
  
  def update
  end
  
  def destroy
  end
  
end
