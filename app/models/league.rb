class League < ActiveRecord::Base
  has_many :teams
  validates :name, :presence => true, :uniqueness => true
  
  def set_draft_time(date, time)
    self.draft_time = "#{date} #{time}"
  end
end
