class UserCache < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
 
  # this model is written by another process
  attr_readonly :user_id, :problem_id, :attempt, :first_accepted_time
  
  validates :problem_id, :presence => true

  def self.find_by_user_and_problem(user, problem)
    UserCache.find(:first, :conditions => [ "user_id = :u and problem_id = :p", { :u => user.id, :p => problem.id} ]) || UserCache.new(:user_id => user.id, :problem_id => problem.id)
  end

  def attempt_html
    if first_accepted_time.nil?
      "<span class=\"green\">#{attempt || ''}</span>"
    else
      '<span class="red">Y</span>'
    end.html_safe
  end
end
