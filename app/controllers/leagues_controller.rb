class LeaguesController < ApplicationController
  def new
    @league = League.new
  end

  def create
    params.required(:league).permit!
    
    league = League.new
    day = params[:draft_day]
    time = params[:draft_time]
    puts day
    puts time
    
    league.update_attributes(params[:league])
    league.set_draft_time(day, time)
    puts league.inspect
    league.save
  end

  def destroy
  end

  def index
  end

  def show
  end
  
end
