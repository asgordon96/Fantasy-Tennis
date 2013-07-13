class User < ActiveRecord::Base
  has_secure_password
  
  has_many :teams
  
  validates :email, :format => { :with => /.+@.+/ },
                    :presence => true,
                    :uniqueness => true
  validates :password, :presence => true, :length => { :minimum => 6}
end
