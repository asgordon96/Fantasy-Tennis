class LeaguesController < ApplicationController
  before_filter :require_login, :only => [:add, :available, :create]
  
  def new
    @league = League.new
  end

  def create
    params.required(:league).permit!
    
    league = League.new
    day = params[:draft_day]
    time = params[:draft_time]
    
    league.assign_attributes(params[:league])
    league.set_draft_time(day, time)

    begin
      league.save!
    rescue => error
      flash[:"alert-error"] = error.message
      redirect_to new_league_path
    end
  end

  def destroy
  end

  def index
    @all_leagues = League.all
  end

  def show
    @league = League.find(params[:id])
    @standings = @league.get_standings
  end
  
  def available
    @league = League.find(params[:id])
    @available = @league.available_players
  end
  
  def add
    @league = League.find(params[:id])
    player = Player.find(params[:player_id])
    team = @league.team_for_user(@user)
    if team.players.length == @league.players_per_team
      flash[:'alert-error'] = "Team already full. Cannot add more players."
      redirect_to available_league_path(@league)
    else
      team.players << player
      team.save
      redirect_to league_team_path(@league, team)
    end
  end
  
end
