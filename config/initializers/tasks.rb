require 'rufus-scheduler'
scheduler = Rufus::Scheduler.start_new
Player.update_players

scheduler.every '24h' do
  Player.update_players
end