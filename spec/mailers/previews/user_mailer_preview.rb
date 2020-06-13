# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.new(email: 'test@example.com', password: 'password', username: 'test')
    UserMailer.welcome_email(user)
  end

  def reset_password
    user = User.new(email: 'test@example.com', password: 'password', username: 'test', reset_password_token: 'xxxxxxxx')
    UserMailer.reset_password(user)
  end
end
