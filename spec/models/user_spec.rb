require 'rails_helper'

RSpec.describe User, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe '.assign_username' do
    context 'when username is blank' do
      it 'assigns username from email prefix string' do
        user = build(:user, email: 'abcde@example.com', password: 'password')
        user.assign_username
        expect(user.username).to eq('abcde')
      end
    end

    context 'when username is not blank' do
      it 'not assigns username from eamil prefix string' do
        user = create(:user, email: 'abcde@example.com', password: 'password', username: 'username')
        expect(user.username).not_to eq('abcde')
      end
    end
  end

  describe '.authenticate' do
    it 'checks if the given password is the same as the user password' do
      user = create(:user, email: 'email@example.com', password: 'password')
      expect(user.authenticate('password')).to eq(true)
    end
  end

  describe '.send_welcome_email' do
    it 'sends welcome_email when user is created' do
      expect(UserMailer).to receive(:welcome_email).once.and_return(double(deliver_later: true))
      create(:user)
    end
  end

  describe '.generate_password_token!' do
    it 'updates the reset_password_token and reset_password_token_expires_at value' do
      user = create(:user)
      travel_to(Time.zone.parse("2020-06-13")) do
        user.generate_password_token!
      end
      expect(user.reset_password_token).not_to eq(nil)
      expected_time = Time.zone.parse("2020-06-13") + 6.hours
      expect(user.reset_password_token_expires_at).to eq(expected_time)
    end
  end

  describe '.clear_password_token!' do
    it 'updates the reset_password_token and reset_password_token_expires_at to nil' do
      user = create(:user)
      user.generate_password_token!
      user.clear_password_token!
      expect(user.reset_password_token_expires_at).to eq(nil)
      expect(user.reset_password_token).to eq(nil)
    end
  end

  describe '.validate_username_length' do
    let(:user) { create(:user, username: 'xxx') }

    context 'when reset_password?' do
      it 'does not check the username length' do
        expect(user).not_to receive(:validate_username_length)
        user.generate_password_token!
      end
    end

    context 'when not reset_password?' do
      it 'checks the username length' do
        expect(user).to receive(:validate_username_length).once
        user.update!(password: 'new_password')
      end
    end
  end

  describe '.reset_password?' do
    it 'checks if reset_password_token is changed' do
      user = create(:user)
      user.reset_password_token = 'xxxxxx'
      expect(user.reset_password?).to eq(true)
    end
  end
end
