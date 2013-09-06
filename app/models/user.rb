class User < ActiveRecord::Base
  has_many :trackings
  has_many :shows, through: :trackings

  has_secure_password

  EMAIL_REGEXP = /^([0-9a-zA-Z]([-\.\w+]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates :password, :length => { :minimum => 6 }
  validates_presence_of :email
  validates_uniqueness_of :username, :email
  validates :email, :format => { :with => EMAIL_REGEXP }

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