require 'rails_helper'

RSpec.describe "User", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe "#edit" do
    #認可されたユーザーとして
    context "as an authorized user" do
      #正常なレスポンスを返すこと
      it "response successfully" do
        sign_in_as user
        get edit_user_path(user)
        expect(response).to be_success
        expect(response).to have_http_status "200"
      end
    end

    #ログインしていないユーザー
    context "as an unauthorized user" do
      #ログイン画面にリダイレクトすること
      it "redirects to the login" do
        get edit_user_path(user)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_url
      end
    end

    #アカウントの違うユーザー
    context "as other user" do
      #ホーム画面にリダイレクトすること
      it "redirects to the login page" do
        sign_in_as other_user
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end
    #フレンドリーフォワーディング
    it "successful edit with friendly forwarding" do
      get edit_user_path(user)
      sign_in_as user
      expect(response).to redirect_to edit_user_path(user)
    end
  end

  describe "#update" do
    #認可されたユーザーとして
    context "as an authorized user" do
      #ユーザーを更新できること
      it "updates a user" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as user
        patch user_path(user), params: {
          id: user.id, user: user_params
        }
        expect(user.reload.name).to eq "NewName"
      end
    end

    #ログインしていないユーザー
    context "as aguest" do
      #ログイン画面にリダイレクトすること
      it "redirect to the login page" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        patch user_path(user), params: {
          id: user.id, user: user_params
        }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_url
      end
    end

    #アカウントが違うユーザー
    context "as other user" do
      #ユーザーを更新できないこと、ホーム画面にリダイレクトすること
      it "does not update" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: {
          id: user.id, user: user_params
        }
        expect(user.reload.name).not_to eq "NewName"
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    #admin属性の変更の禁止
    #it "should not allow the admin attribute to be edited via the web" do
      #sign_in_as other_user
      #expect(other_user).not_to be_admin
      #patch user_path(other_user), prams: {
        #user: {
          #password: other_user.password,
          #password_confirmation: other_user.password,
          #admin: true
        #}
      #}
      #expect(other_user.reload).not_to be_admin
    #end
    
    #ログインしていないユーザー
    context "as a guest" do
      #ユーザーの削除はできずログイン画面にリダイレクトされる
      it "does not destroy" do
        expect{
          delete user_path(other_user), params: {
            id: other_user.id
          }
        }.to change(User, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_url
      end
    end

    #管理者でないユーザー
    context "non-admin" do
      #ユーザーの削除はできずホーム画面にリダイレクトされる
      it "does not destroy" do
        sign_in_as other_user
        expect{
          delete user_path(user), params: {
            id: user.id
          }
        }.to change(User, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_url
      end
    end
  end
  #アカウント有効化のテストも含めて#createをテストする
  describe "#create" do
    include ActiveJob::TestHelper
    #アカウントの登録ができる
    it "is valid" do
      perform_enqueued_jobs do
        expect{
          post users_path, params: {
            user: {
              name: "ExampleUser",
              email: "user@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.to change(User, :count).by(1)
        expect(response).to redirect_to root_url
        user = assigns(:user)
        #有効化していないユーザーでログイン
        sign_in_as user
        expect(session[:user_id]).to be_falsey
        #有効化トークンが不正な場合
        get edit_account_activation_path("invalid token", email: user.email)
        expect(session[:user_id]).to be_falsey
        #トークンは正しいがメールアドレスが無効な場合
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        expect(session[:user_id]).to be_falsey
        #有効化トークンが正しい場合
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(session[:user_id]).to eq user.id
        expect(user.name).to eq "ExampleUser"
        expect(user.email).to eq "user@example.com"
        expect(user.password).to eq "password"
      end
    end
  end

  describe "#show" do
    let(:non_activated_user) { FactoryBot.create(:user, :non_activated_user) }
    
    #有効化されてないユーザーの詳細ページにはアクセスできない
    it "show only activated user" do
      sign_in_as user
      get user_path(user)
      expect(response).to be_success
      get user_path(non_activated_user)
      expect(response).to redirect_to root_url
    end
  end
end
