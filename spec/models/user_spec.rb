require 'spec_helper'

describe User do
  it "should validate" do
    user = User.new
    user.should_not be_valid
    user.email = "blah"
    user.should_not be_valid
    user.email = "test.@gmail.com"
    user.password = "password"
    user.password_confirmation = "password"
    user.should be_valid  
  end
  
  describe "authenticate user" do
    let(:user) { User.new }
    
    it "should authenticate with valid password" do
      user.password = "password"
      user.authenticate("password").should == user
    end
  
    it "should not authenticate with wrong password" do
      user.password = "password"
      user.authenticate("wrong").should be_false
    end
  end
  
end
