class User < ActiveRecord::Base
  has_many :trackings
  has_many :shows, through: :trackings
  has_secure_password

  EMAIL_REGEXP = /^([0-9a-zA-Z]([-\.\w+]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/

  attr_accessible :email, :password

  validates_presence_of :password, :on => :create, unless: :guest?
  validates :password, :length => { :minimum => 3 }, unless: :guest?
  validates_presence_of :email, :password_digest, unless: :guest?
  validates_uniqueness_of :email, unless: :guest?
  validates :email, :format => { :with => EMAIL_REGEXP }, unless: :guest?

  require 'bcrypt'
  attr_reader :password
  include ActiveModel::SecurePassword::InstanceMethodsOnActivation

  def name
    guest ? "Guest" : email
  end

  def move_to(user)
    user.shows << shows
  end

  def self.new_guest
    random_password = SecureRandom.hex(4)

    new do |u|
      u.guest = true 
      u.password = random_password 
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_digest = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end