# == Schema Information
# Schema version: 20101128080757
#
# Table name: problems
#
#  id           :integer         not null, primary key
#  title        :string(255)     not null
#  source       :string(255)
#  memory_limit :integer         not null
#  time_limit   :integer         not null
#  accept_count :integer
#  submit_count :integer
#  created_at   :datetime
#  updated_at   :datetime
#


class Problem < ActiveRecord::Base
  has_many :submissions, :dependent => :destroy
  has_many :problem_links, :dependent => :destroy
  has_many :contests, :through => :problem_links

  attr_accessible :name, :title, :time_limit, :memory_limit, :source, :accept_count, :submit_count

end
