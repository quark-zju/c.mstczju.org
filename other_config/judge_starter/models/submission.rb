# == Schema Information
# Schema version: 20101128080757
#
# Table name: submissions
#
#  id            :integer         not null, primary key
#  problem_id    :integer
#  user_id       :integer
#  result        :integer
#  used_memory   :integer
#  used_time     :integer
#  lang          :string(255)
#  visible_group :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Submission < ActiveRecord::Base
  default_scope :order => 'submissions.created_at DESC'
  
  attr_accessible :problem_id, :user_id, :result, :used_memory, :used_time, :lang, :visible_group
  #, :code
  attr_readonly :id, :created_at

  belongs_to :user
  belongs_to :problem
end
