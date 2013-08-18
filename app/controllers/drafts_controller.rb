class DraftsController < ApplicationController
  before_filter :require_login
  before_filter :require_team
  
  def show
    @available = @league.available_players
    @draft_order = @league.teams.shuffle
  end
  
  def buyplayer
    @team.add_player_by_name(params[:player])
    render :json => {}
  end
  
  def require_team
    @league = League.find(params[:league_id])
    @team = @league.team_for_user(@user)
    if not @team
      raise ActionController::RoutingError, "Not Found"
    end
  end
  
end
