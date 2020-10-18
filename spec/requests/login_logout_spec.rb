require 'rails_helper'

RSpec.describe "LoginLogout", type: :request do
  let(:user) { FactoryBot.create(:user) }

  #ログインのメソッド
  def post_valid_user(remember_me = 0)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_me: remember_me
      }
    }
  end
  
  #チェックボックスのテスト
  describe "checkbox" do
    context "check remember_me" do
      #トークンが作られていること
      it "succes remember_token" do
        get login_path
        post_valid_user(1)
        expect(cookies[:remember_token]).not_to be_nil
      end
      #ログアウト後のログインでトークンが残っていないか
      it "has no remember_token when users logged out and logged in" do
        get login_path
        post_valid_user(1)
        expect(cookies[:remember_token]).not_to be_empty
        delete logout_path
        expect(cookies[:remember_token]).to be_empty
      end
    end
    
    #オフの時はトークンが作られてないこと
    it "no remember_token" do
      get login_path
      post_valid_user(0)
      expect(cookies[:remember_token]).to be_nil
    end
    
  end
  
  
  #ログイン、ログアウトができること
  it "login" do
    get login_path
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password
      }
    }
    expect(is_logged_in?).to be_truthy
    delete logout_path
    expect(is_logged_in?).to be_falsey
  end
end
