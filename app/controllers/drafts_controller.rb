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
    @draft.player = "Waiting for nomination..."
    @draft.get_next_nominator
    @draft.bid = 0
    @draft.current_team = nil
    @draft.save!
    puts @draft.inspect
    render :json => {}
  end
  
  def myteam
    render :partial => 'team'
  end
  
  def available
    @available = @league.available_players
    render :partial => 'available'
  end
  
  def nominator
    nom = @league.draft.nominator
    if nom
      render :json => {:nominator => @league.draft.nominator.name}
    else
      render :json => {:nominator => ""} # this won't match any team name
    end
  end
  
  def require_team
    @league = League.find(params[:league_id])
    @draft = @league.draft
    @team = @league.team_for_user(@user)
    if not @team
      raise ActionController::RoutingError, "Not Found"
    end
  end
  
end
