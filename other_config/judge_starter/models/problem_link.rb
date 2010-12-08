class ProblemLink < ActiveRecord::Base
  attr_accessible :problem_id, :contest_id, :name

  belongs_to :contest
  belongs_to :problem
  
  validates :name, :presence => true, :length => { :within => 1..16 }
  validates :contest_id, :presence => true
  validates :problem_id, :presence => true

  validates_presence_of :contest, :problem

end
