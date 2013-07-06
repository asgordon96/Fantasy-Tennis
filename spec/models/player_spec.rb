require 'spec_helper'

describe Player do
  
  it "sets wins losses and rank" do
    player = Player.new
    player.firstname = "Juan Martin"
    player.lastname = "Del Potro"
    player.save
    player.get_stats
    
    player.rank.should == 8
    player.wins.should == 20
    player.losses.should == 8
  end
  
  it "returns top 100 players" do
    top100 = Player.get_rankings
    top100.length.should == 100
    top100.each do |p|
      p.should be_a(Player)
    end
  end
  
end