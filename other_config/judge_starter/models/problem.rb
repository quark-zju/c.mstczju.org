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

  before_save :reset_counts
  after_save :create_directory

  validates :title, :presence => true, :length => { :within => 1..40 }
  validates :memory_limit, :presence => true
  validates :time_limit, :presence => true

  def raw_text
    file_path = "#{path}/text"
    return '' unless File.exists? file_path
    content = File.read file_path
  end

  private

  def path
    "#{RAILS_ROOT}/data/p/#{path_from_id(self.id)}"
  end

  def reset_counts
    self.accept_count = self.submit_count = 0 if new_record? or self.submit_count.nil?
  end

  def create_directory
    Dir.mkdir_as_needed path
    # write info
    File.open("#{path}/info.txt", 'w') do |info|
      info.puts "-- Title: #{title}"
      info.puts "limits = { time = #{time_limit}, memory = #{memory_limit} }"
    end
  end

  def path_from_id(id)
    r = sprintf("%06x", id)
    "#{r[0..1]}/#{r[2..3]}/#{r[4..5]}"
  end

end
