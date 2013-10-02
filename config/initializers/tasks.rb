require 'rufus-scheduler'
scheduler = Rufus::Scheduler.start_new

# scheduler.every '24h' do
#   Player.update_players
# end
scheduler.every '1s' do
  puts "Here's the Scheduler"
end
