require 'spec_helper'

describe Team do
  
  before(:each) do
    @team = Team.new
    @team.name = "New Team"
    @team.total_points = 0
    @team.save
  end
  
  it "adds to points_total" do
    @team.add_points(10)
    @team.total_points.should == 10
  end
  
  it "is not valid without name" do
    @team.name = ""
    @team.valid?.should == false
    @team.name = nil
    @team.valid?.should == false
  end
    
end
