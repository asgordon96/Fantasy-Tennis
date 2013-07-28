class LeaguesController < ApplicationController
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
  end
  
end
