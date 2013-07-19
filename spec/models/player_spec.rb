require 'spec_helper'

describe Player do
  
  it "sets wins losses and rank" do
    player = Player.new
    player.link_name = '/Tennis/Players/Top-Players/Jo-Wilfried-Tsonga.aspx'
    player.save
    player.get_stats
    
    player.rank.should == 8
    player.wins.should == 30
    player.losses.should == 11
    player.name.should == "Jo-Wilfried Tsonga"
  end
  
  it "returns top 100 players" do
    Player.get_rankings
    top100 = Player.all
    top100.length.should == 100
    top100.each do |p|
      p.should be_a(Player)
      p.link_name.should be_true
    end
  end
  
  it "gets the year-do-date ATP points for the top 100" do
    Player.get_rankings
    Player.get_ytd_points(100)
    nadal = Player.find_by_link_name("/Tennis/Players/Top-Players/Rafael-Nadal.aspx")
    nadal.atp_points.should == 7010
    robredo = Player.find_by_link_name("/Tennis/Players/Top-Players/Tommy-Robredo.aspx")
    robredo.atp_points.should == 1065
  end
    
  it "gets ytd ATP points for 101-200" do
      Player.get_rankings
      Player.get_ytd_points(100)
      Player.get_ytd_points(200)
      schepper = Player.find_by_link_name('/Tennis/Players/De/K/Kenny-De-Schepper.aspx')
      schepper.atp_points.should == 456
  end
  
  it "has a country" do
    Player.get_rankings
    andy = Player.find_by_link_name('/Tennis/Players/Top-Players/Andy-Murray.aspx')
    andy.should respond_to(:country)
    andy.country.should == "GBR"
  end
  
  it "should update rankings with country" do
    Player.get_rankings
    andy = Player.find_by_link_name('/Tennis/Players/Top-Players/Andy-Murray.aspx')
    andy.link_name = "We messed up!"
    andy.save
    Player.update_rankings
    new_andy = Player.find_by_link_name('/Tennis/Players/Top-Players/Andy-Murray.aspx')
    new_andy.country.should == "GBR"
    
  end
  
  
end