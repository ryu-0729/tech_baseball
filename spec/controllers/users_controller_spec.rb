require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  
  describe "#index" do 
    #認証済みのユーザーとして
    context "as an authenticated user" do
      #正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in user
        get :index
        aggregate_failures do
          expect(response).to be_success
          expect(response).to have_http_status "200"
        end
      end
    end
    
    #ゲストとして
    context "as a guest" do
      #302レスポンスを返しログイン画面にリダイレクトする
      it "response and redirect successfully" do
        get :index
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to login_url
        end
      end
    end
  end
  
  describe "#new" do
    #レスポンスが正しいこと
    it "response successfully" do
      get :new
      expect(response).to be_success
    end
  end
  
  describe "#show" do 
    #レスポンスが正しいこと
    it "response succesfully" do
      get :show, params: { id: user.id }
      expect(response).to be_success
    end
  end

  describe "#edit" do
    #認可されたユーザーとして
    context "as an authorized user" do
      #レスポンスが正しいこと
      it "response successfully" do
        sign_in user
        get :edit, params: { id: user.id }
        expect(response).to be_success
      end
    end
    #認可されてないユーザーとして
    context "as an unauthorized user" do
      #ログインページにリダイレクトすること
      it "redirects to the login" do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to login_url
      end
    end
  end
end
