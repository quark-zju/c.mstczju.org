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
  attr_accessible :start_time, :end_time, :freeze_time, :visible_group, :moderate_group, :path, :name
  has_many :problem_links, :dependent => :destroy
  has_many :problems, :through => :problem_links

  validates :start_time, :presence => true

  def started?
    Time.now > start_time
  end

  def frozen?
    Time.now > freeze_time and Time.now < end_time
  end

  def moderate_by?(user)
    if user 
      if user.group =~ /\badmin\b/
        true
      elsif moderate_group and not moderate_group.empty? and current_user.group =~ /\b#{moderate_group}\b/
        true
      else
        false
      end
    else
      false
    end
  end
end
