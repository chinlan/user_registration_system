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

    context 'when edit_username?' do
      it 'does not check the username length' do
        expect(user).not_to receive(:validate_username_length)
        user.update(password: 'new_password')
      end
    end

    context 'when not edit_username?' do
      it 'checks the username length' do
        expect(user).to receive(:validate_username_length).once
        user.update!(username: 'new_username')
      end
    end
  end

  describe '.edit_username?' do
    it 'checks if username is changed' do
      user = create(:user)
      user.username = 'xxxxxxx'
      expect(user.edit_username?).to eq(true)
    end
  end

  describe 'validate password length' do
    context 'when length is less than 8' do
      it 'is invalid' do
        user = build(:user, password: 'ppp', email: 'test@example.com')
        expect(user.valid?).to eq(false)
      end
    end

    context 'when length is more or equal to 8' do
      it 'is valid' do
        user = build(:user, password: 'password', email: 'test@example.com')
        expect(user.valid?).to eq(true)
      end
    end
  end

  describe 'validate email format' do
    context 'when format is wrong' do
      it 'is invalid' do
        user = build(:user, password: 'ppp', email: 'testexamplecom')
        expect(user.valid?).to eq(false)
      end
    end

    context 'when length is more or equal to 8' do
      it 'is valid' do
        user = build(:user, password: 'password', email: 'test@example.com')
        expect(user.valid?).to eq(true)
      end
    end
  end
end
