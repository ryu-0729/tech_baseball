require 'rails_helper'

RSpec.describe "Users", type: :system do
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

  #無効なユーザー
  it "Invalid Sign up User" do
    visit root_path
    expect{
      click_link "Sign up now!"
      fill_in "Name",	with: ""
      fill_in "Email",	with: ""
      fill_in "Password",	with: ""
      fill_in "Confirmation",	with: ""
      click_button "Create my account"
      expect(current_path).to eq "/signup"
      #expect(page).to have_content "4 errors prohibited this user from being saved:"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    }.not_to change(User, :count)
  end
end
