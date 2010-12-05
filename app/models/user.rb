class User < ActiveRecord::Base
  has_many :submissions, :dependent => :destroy

end
