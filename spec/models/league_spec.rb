require 'spec_helper'

describe League do
  before(:each) do
    @league = League.new
    @league.name = "Test League"
    @league.draft_time = Time.now
    @league.save
  end
  
  it "is invalid without name" do
    @league.name = ""
    @league.should_not be_valid
    @league.name = nil
    @league.should_not be_valid
  end
  
  it "is invalid without unique name" do
    new_league = League.new
    new_league.name = "Test League"
    new_league.draft_time = Time.now
    new_league.save
    new_league.should_not be_valid
  end
  
  
end
