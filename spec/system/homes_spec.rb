require 'rails_helper'

RSpec.describe "Homes", type: :system do
  #homeページにhello worldが表示される
  #ページタイトルも表示されてること
  it "Hello World" do
    visit root_path
    expect(page).to have_content "Hello World!"
    expect(page).to have_title 'Home'
  end
end
