class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  validate_associated :user
  validate_associated :problem
end
