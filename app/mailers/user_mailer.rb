class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Thank you for registering UserRegistrationSystem!')
  end
end
