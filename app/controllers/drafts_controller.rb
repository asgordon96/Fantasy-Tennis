class DraftsController < ApplicationController
  before_filter :require_login
  before_filter :require_team
  
  def show
    @available = @league.available_players
    order = @league.draft.order
    @league.get_draft_order
    @draft = @league.draft
    @draft_order = Team.teams_from_ids(@league.draft.order)
  end
  
  def buyplayer
    @team.add_player_by_name(params[:player])
    render :json => {}
  end
  
  def myteam
    render :partial => 'team'
  end
  
  def available
    @available = @league.available_players
    render :partial => 'available'
  end
  
  def require_team
    @league = League.find(params[:league_id])
    @team = @league.team_for_user(@user)
    if not @team
      raise ActionController::RoutingError, "Not Found"
    end
  end
  
end
