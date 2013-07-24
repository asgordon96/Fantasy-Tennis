require 'nokogiri'
require 'open-uri'

class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  
  # initialize all the top 100 players with stats
  def self.init_players
    Player.get_rankings
    Player.get_ytd_points(100)
    Player.get_ytd_points(200)
    all_players = Player.all
    all_players.each do |player|
      player.get_stats
      if not player.atp_points
        player.atp_points = 0
      end
      player.save
      puts "Loaded #{player.name}"
    end
  end
  
  # update the players stats, and get the new top 100
  def self.update_players
    Player.update_rankings
    Player.all.each do |player|
      player.get_stats
    end
    Player.get_ytd_points(100)
    Player.get_ytd_points(200)
  end
  
  # get the year-to-date points for the top 100
  def self.get_ytd_points(ranks)
    if ranks == 100
      # get the top 100
      url = "http://m.atpworldtour.com/Rankings/YTD-Singles.aspx"
    elsif ranks == 200
      # get 101-200
      url = "http://m.atpworldtour.com/Rankings/YTD-Singles.aspx?r=101#"
    else
      puts "Invalid"
      return
    end
    
    page = Nokogiri::HTML(open(url))
    
    player_links = page.css(".playerName").css("a").map do |tag|
      tag["href"]
    end
    player_points = page.css(".playerPoints").map do |tag|
      Integer(tag.text.sub(',', ''))
    end
    
    data = player_links.zip(player_points)
    data.each do |row|
      player = Player.find_by_link_name(row[0])
      if player
        player.atp_points = row[1]
        player.save
      end
    end
    
  end
  
  # get the top 100 ranked players
  def self.get_rankings
    url = "http://m.atpworldtour.com/Rankings/Singles.aspx"
    page = Nokogiri::HTML(open(url))
    player_links = page.css(".playerName").css("a")
    player_countries = page.css(".playerNameNat").map { |el| el.text.delete('()') }
    player_links.each_with_index do |link, index|
      new_player = Player.new
      new_player.link_name = link["href"]
      new_player.country = player_countries[index]
      new_player.save
      new_player
    end
  end
  
  # update the top 100
  def self.update_rankings
    url = "http://m.atpworldtour.com/Rankings/Singles.aspx"
    page = Nokogiri::HTML(open(url))
    player_links = page.css(".playerName").css("a")
    player_countries = page.css(".playerNameNat").map { |el| el.text.delete('()') }
    links = player_links.map do |link|
      link["href"]
    end
    
    # remove players no longer in the top 100
    Player.all.each do |player|
      if not links.include?(player.link_name)
        player.destroy
      end
    end
    
    # add new players in the top 100
    old_links = Player.all.map { |p| p.link_name }
    links.each_with_index do |link, index|
      if not old_links.include?(link)
        new_player = Player.new
        new_player.link_name = link
        new_player.country = player_countries[index]
        new_player.save
      end
    end
    
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
  
  # get the ATP points and add the total to teams
  def update_atp_points(points)
    old_points = self.atp_points
    diff = points - old_points
    self.atp_points = points
    self.save
    self.teams.each do |team|
      team.add_points(diff)
    end
  end
  
  def full_link
    "http://www.atpworldtour.com#{self.link_name}"
  end
  
end
