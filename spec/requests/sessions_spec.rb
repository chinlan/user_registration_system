require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get login_path
      expect(response.status).to eq(200)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get logout_path
      expect(response.status).to eq(302)
    end
  end
end
