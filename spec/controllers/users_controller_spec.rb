require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#new" do
    #レスポンスが正しいこと
    it "response successfully" do
      get :new
      expect(response).to be_success
    end
  end
  
  describe "#show" do
    let(:user) { FactoryBot.create(:user) } 
    #レスポンスが正しいこと
    it "response succesfully" do
      get :show, params: { id: user.id }
      expect(response).to be_success
    end
  end
  
end
