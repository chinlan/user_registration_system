require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { create(:user) }

  describe 'POST /password_resets' do
    let(:params) do
      {
        user: {
          email: user.email
        }
      }
    end

    subject do
      post '/password_resets', params: params
    end

    it 'sends reset_password email and always returns successful response' do
      expect(UserMailer).to receive(:reset_password).once.and_return(double(deliver_later: true))
      subject
      expect(response.status).to eq(302)
    end
  end

  describe 'GET /password_resets/:token/edit' do
    subject do
      get "/password_resets/#{user.reset_password_token}/edit"
    end

    before do
      user.generate_password_token!
    end

    context 'when token is not expired' do
      it 'renders edit page successfully' do
        subject
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
      end
    end

    context 'when token is expired' do
      before do
        user.update(reset_password_token_expires_at: 1.day.ago)
      end

      it 'redirect_to root_path with flash alert message' do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PUT /password_resets/:token' do
    subject do
      put "/password_resets/#{user.reset_password_token}", params: params
    end

    before do
      user.generate_password_token!
    end

    context 'when success' do
      let(:params) do
        {
          user: {
            password: 'new_password'
          }
        }
      end

      it 'updates the password' do
        subject
        expect(response.status).to eq(302)
        expect(user.reload.password).to eq('new_password')
      end
    end

    context 'when fail' do
      let(:params) do
        {
          user: {
            password: 'new'
          }
        }
      end

      it 'renders edit page with alert flash message' do
        subject
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
