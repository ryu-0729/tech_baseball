require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) } 
  #ユーザーの新規登録
  it "Sign up User" do
    visit root_path
    expect{
      click_link "Sign up now!"
      fill_in "Name",	with: "Ryu"
      fill_in "Email",	with: "example@exaple.com"
      fill_in "Password",	with: "password"
      fill_in "Confirmation",	with: "password"
      click_button "Create my account"
      expect(page).to have_content "Welcome to the Tech Baseball!"
      expect(page).not_to have_link "Log in"
    }.to change(User, :count).by(1)
  end

  #無効なユーザーの新規登録
  it "Invalid Sign up User" do
    visit root_path
    expect{
      click_link "Sign up now!"
      fill_in "Name",	with: ""
      fill_in "Email",	with: ""
      fill_in "Password",	with: ""
      fill_in "Confirmation",	with: ""
      click_button "Create my account"
      expect(current_path).to eq "/users"
      #expect(page).to have_content "4 errors prohibited this user from being saved:"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    }.not_to change(User, :count)
  end

  #ユーザーの編集
  describe "user edit" do
    #編集の成功
    it "success" do
      valid_login(user)
      click_link "Account"
      click_link "Settings"
      fill_in "Name",	with: "Edit" 
      fill_in "Email",	with: "baseball@example.com"
      fill_in "Password",	with: ""
      fill_in "Confirmation",	with: ""
      click_button "Save changes"
      expect(current_path).to eq user_path(user)
      expect(user.reload.email).to eq "baseball@example.com"
    end
    
    #編集の失敗
    it "unsuccess" do
      valid_login(user)
      click_link "Account"
      click_link "Settings"
      fill_in "Name",	with: ""
      fill_in "Email",	with: "foo@invalid"
      fill_in "Password",	with: "foo"
      fill_in "Confirmation",	with: "bar"
      click_button "Save changes"
      expect(user.reload.email).not_to eq "foo@invalid"
    end
    
  end
  
end
