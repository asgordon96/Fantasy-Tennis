class DraftsController < ApplicationController
  def show
    league = League.find(params[:league_id])
    @available = league.available_players
  end
end
