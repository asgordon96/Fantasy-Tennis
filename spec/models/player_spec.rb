require 'spec_helper'

describe Player do
  
  it "sets wins losses and rank" do
    player = Player.new
    player.link_name = '/Tennis/Players/Top-Players/Jo-Wilfried-Tsonga.aspx'
    player.save
    player.get_stats
    
    player.rank.should == 7
    player.wins.should == 29
    player.losses.should == 10
    player.name.should == "Jo-Wilfried Tsonga"
  end
  
  it "returns top 100 players" do
    top100 = Player.get_rankings
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
    nadal.atp_points.should == 7000
    robredo = Player.find_by_link_name("/Tennis/Players/Top-Players/Tommy-Robredo.aspx")
    robredo.atp_points.should == 975
  end
    
  it "gets ytd ATP points for 101-200" do
      Player.get_rankings
      Player.get_ytd_points(200)
      hewitt = Player.find_by_link_name('/Tennis/Players/Top-Players/Lleyton-Hewitt.aspx')
      hewitt.atp_points.should == 265
      schepper = Player.find_by_link_name('/Tennis/Players/De/K/Kenny-De-Schepper.aspx')
      schepper.atp_points.should == 276
  end
  
end