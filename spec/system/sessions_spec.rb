require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { FactoryBot.create(:user) }

  #ユーザーのログイン
  it "user sign in" do
    visit root_path
    expect{ 
      click_link "Log in"
      fill_in "Email",	with: user.email
      fill_in "Password",	with: user.password
      click_button "Log in"
      expect(user).to be_valid
    }.to change(User, :count).by(1)
  end
end
