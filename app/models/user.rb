class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: { case_sensitive: true }, length: { minimum: 8 }
  validate on: :update do
    validate_username_length unless reset_password
  end

  before_save :assign_username, if: -> { username.blank? }
  after_create :send_welcome_mail

  def assign_username
    self.username = email.match(/(.+)@/)[1]
  end

  def authenticate(given_password)
    given_password == password
  end

  def send_welcome_mail
    UserMailer.welcome_email(self).deliver_later
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    self.reset_password_token_expires_at = 6.hours.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end

  def validate_username_length
    username.length >= 5
  end

  def reset_password
    reset_password_token_changed?
  end
end
