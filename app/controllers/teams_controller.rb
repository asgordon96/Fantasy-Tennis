class TeamsController < ApplicationController
  
  before_filter :require_login
  
  def show
    @team = Team.find(params[:id])
    @players = @team.players
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
  
end
