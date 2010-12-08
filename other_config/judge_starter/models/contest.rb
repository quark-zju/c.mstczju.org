# == Schema Information
# Schema version: 20101128080757
#
# Table name: contests
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  start_time     :datetime
#  freeze_time    :datetime
#  end_time       :datetime
#  visible_group  :string(255)
#  moderate_group :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Contest < ActiveRecord::Base
  attr_accessible :start_time, :end_time, :frozen_time, :visible_group, :moderate_group, :path, :name
  has_many :problem_links, :dependent => :destroy
  has_many :problems, :through => :problem_links

end
