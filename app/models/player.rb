require 'nokogiri'
require 'open-uri'

class Player < ActiveRecord::Base
  
  # get the top 100 ranked players
  def self.get_rankings
    url = "http://m.atpworldtour.com/Rankings/Singles.aspx"
    page = Nokogiri::HTML(open(url))
    player_links = page.css(".playerName").css("a")
    players = player_links.map do |link|
      new_player = Player.new
      new_player.link_name = link["href"]
      new_player.save
      new_player
    end
    players 
  end
  
  # for the Player, get wins, losses, and rank from the ATP website
  def get_stats
    player_url = "http://m.atpworldtour.com#{self.link_name}"
    player_html = Nokogiri::HTML(open(player_url))
    
    player_name = player_html.css(".playerDetailsName")[0].css("strong").text
    
    table = player_html.css(".psdCurrent")[0]
    current_rank = Integer(table.css(".psdrRank")[0].text)
    win_loss = table.css(".psdWL")[0].text
    season_wins = Integer(win_loss.split('-')[0])
    season_losses = Integer(win_loss.split('-')[1])
    
    self.name = player_name
    self.rank = current_rank
    self.wins = season_wins
    self.losses = season_losses
    self.save
  end
end
