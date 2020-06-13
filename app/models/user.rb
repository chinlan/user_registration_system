class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: { case_sensitive: true }, length: { minimum: 8 }

  before_save :assign_username, if: -> { username.blank? }

  def assign_username
    self.username = email.match(/(.+)@/)[1]
  end

  def authenticate(given_password)
    given_password == password
  end
end
