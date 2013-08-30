require 'eventmachine'
require 'faye'
module FayeClient
  def self.start
    EM.run do
      client = Faye::Client.new('http://localhost:3000/faye')
      client.subscribe("/*") do |message|
        league_id = message["id"]
        league = League.find(league_id)
        draft = league.draft
        if message["type"] == "nominate"
          draft.player = message["player"]
          draft.bid = 1
          draft.current_team = league.teams.find_by_name(message["team"])
          draft.save
          puts "Current Player: #{draft.player}"
        elsif message["type"] == "bid"
          draft.bid = message["bid"]
          draft.current_team = league.teams.find_by_name(message["team"])
          draft.save
          puts "Current Bid: #{draft.bid} by #{draft.current_team.name}"
        end
      end
    end
  end
end