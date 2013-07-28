module LeaguesHelper
  def format_draft_date(league)
    t = league.draft_time
    t.strftime("%a %b #{t.day.ordinalize} %I:%M %p")
  end
  
end
