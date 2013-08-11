class DraftsController < ApplicationController
  before_filter :require_login
  
  def show
    @league = League.find(params[:league_id])
    @team = @league.team_for_user(@user)
    @available = @league.available_players
  end
end
