require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  describe "#welcome_email" do
    it "sends welcome email" do
      mail = UserMailer.welcome_email(user)
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('Thank you for registering UserRegistrationSystem!')
      expect(mail.text_part.body.encoded).to match(user.username)
    end
  end

  describe "#reset_password" do
    it "sends reset password email" do
      mail = UserMailer.reset_password(user)
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('Reset your password')
      expect(mail.text_part.body.encoded).to match(user.username)
    end
  end
end
