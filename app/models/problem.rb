class Problem < ActiveRecord::Base
  has_many :submissions, :dependent => :destroy
  has_and_belongs_to_many :contests
end
