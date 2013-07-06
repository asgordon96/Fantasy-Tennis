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
  
end