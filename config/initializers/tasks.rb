require 'rufus-scheduler'
scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 6 * * 1 *' do
  puts "Updating all the players..."
  Player.update_players
end
