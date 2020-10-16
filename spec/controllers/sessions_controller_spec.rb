require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#new" do
    #レスポンスが正しいこと
    it "response successfully" do
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    let(:user) { FactoryBot.create(:user) }
    #レスポンスが正しいこと
    it "response successfully" do
      sign_in user
      expect(response).to be_success  
    end
  end

  describe "#destroy" do
    let(:user) { FactoryBot.create(:user) } 
    it "log out" do
      sign_in user
      delete :destroy, params: {
        id: user.id
      }
      expect(is_logged_in?).to be_falsey
    end
  end
end
