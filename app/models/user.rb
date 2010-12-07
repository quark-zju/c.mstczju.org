# == Schema Information
# Schema version: 20101128080757
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  nick               :string(255)
#  group              :string(255)
#  email              :string(255)
#  salt               :string(255)
#  encrypted_password :string(255)
#  signature          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password, :verify_password
  attr_accessible :signature, :password, :password_confirmation, :nick
  attr_accessible :name, :group, :email
  attr_readonly :id
  #attr_readonly :name, :group, :email

  has_many :submissions, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :password, :presence => true, :confirmation => true, :length => { :within => 3..40 }
  validates :name, :presence => true, :length => { :within => 3..40 } 
  validates :email, :format => { :with => email_regex },
    :presence => true, :length => { :within => 3..40 }, :uniqueness => { :case_sensitive => false }
  validates :nick, :presence => true, :length => { :within => 1..64 }

  before_save :encrypt_password 

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def self.authenticate(name, submitted_password)
    user = find_by_name(name) || find_by_email(name) || find_by_nick(name)
    if user.nil? or not user.has_password?(submitted_password)
      nil
    else
      # authenticate successful, consider update salt
      user.update_attributes(:password => submitted_password)
      user
    end
  end  
  
  private
  
  def update_salt
    self.salt = secure_hash("#{Time.now.utc}--#{password}")
  end

  def encrypt_password
    update_salt
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end
