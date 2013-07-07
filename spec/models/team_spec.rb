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
  
end
