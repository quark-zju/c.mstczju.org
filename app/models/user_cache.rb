class UserCache < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  
  attr_accessible :user_id, :problem_id, :attempt, :first_accepted_time
end
