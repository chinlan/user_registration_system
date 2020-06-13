require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    subject do
      post '/users', params: params
    end

    context 'when success' do
      let(:params) do
        {
          user: {
            email: '111@exaple.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it "creates new user" do
        expect{ subject }.to change{ User.count }.by(1)
        expect(response.status).to eq(302)
        user = User.last
        expect(user.email).to eq('111@exaple.com')
        expect(user.password).to eq('password')
      end
    end

    context 'when given invalid params' do
      let(:params) do
        {
          user: {
            email: '111exapleom',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it "fails to create new user" do
        expect{ subject }.to change{ User.count }.by(0)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PUT /users/:id" do
    let(:user) { create(:user) }

    subject do
      put "/users/#{user.id}", params: params
    end

    context 'when success' do
      let(:params) do
        {
          user: {
            username: 'Username',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it "updates the user" do
        subject
        expect(response.status).to eq(302)
        expect(user.reload.username).to eq('Username')
      end
    end

    context 'when given invalid params' do
      let(:params) do
        {
          user: {
            username: 'xxx',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it "fails to update the user" do
        subject
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
