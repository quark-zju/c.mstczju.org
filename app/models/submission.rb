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
  
  attr_accessible :problem_id, :user_id, :result, :used_memory, :used_time, :lang, :visible_group, :code
  attr_readonly :id

  belongs_to :user
  belongs_to :problem

  validates_presence_of :user
  validates_presence_of :problem
  
  validates :code, :length => { :within => 1..65536 }
  validates :result, :presence => true
  validates :lang, :presence => true

  after_save :create_directory

  def code=(new_code)
    @code = new_code
  end

  def code
    if @code.nil? and not self.id.nil?
      # load from file
      @code = File.read "#{path}/code"
    end
    @code
  end

  def owner?(test_user)
    self.user == test_user 
  end

  private

  def path
    "#{RAILS_ROOT}/data/s/#{path_from_id(self.id)}"
  end

  def create_directory
    Dir.mkdir_as_needed path
    # write info
    File.open("#{path}/code", 'w') do |info|
      info.print @code 
    end
  end

  def path_from_id(id)
    r = sprintf("%08x", id)
    "#{r[0..1]}/#{r[2..3]}/#{r[4..5]}/#{r[6..7]}"
  end
end
