require 'rails_helper'

RSpec.describe User, type: :model do 
  #有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  
  #名前がなければ無効な状態であること
  it { is_expected.to validate_presence_of :name }
  #名前が50文字を超えていたら無効な状態であること
  it { should validate_length_of(:name).is_at_most(50) }

  #emailがなければ無効な状態であること
  it { is_expected.to validate_presence_of :email }
  #emailが255文字を超えていたら無効な状態であること
  it { should validate_length_of(:email).is_at_most(255) }
  #以下のemailは有効であること
  it do
    is_expected.to allow_values('first.last@foo.jp',
                                'user@example.com',
                                'USER@foo.COM',
                                'A_US_ER@foo.bar.org',
                                'alice+bob@baz.cn').for(:email)
  end
  #以下のemailは無効な状態であること
  it do
    is_expected.not_to allow_values('user@example,com',
                                    'user_at_foo.org',
                                    'user.name@example.',
                                    'foo@bar_baz.com',
                                    'foo@bar+baz.com',
                                    'foo@bar..com').for(:email)
  end
  #emailの重複は無効である
  #it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  describe "validate unqueness of email" do
    let!(:user) { FactoryBot.create(:user, email: 'original@example.com') } 
    it "is invalid with a duplicate email" do
      user = FactoryBot.build(:user, email: 'original@example.com')
      expect(user).not_to be_valid
    end
    it "is case insensitive in email" do
      user = FactoryBot.build(:user, email: 'ORIGINAL@EXAMPLE.COM')
      expect(user).not_to be_valid
    end
  end
  
  #emailが小文字で保存されること
  describe "#email_downcase" do
    let!(:user) { FactoryBot.create(:user, email: 'ORIGINAL@EXAMPLE.COM') } 
    it "make email to low case" do
      expect(user.reload.email).to eq 'original@example.com'
    end
  end
  
  #passwordが空なら無効であること
  #it { is_expected.to validate_presence_of :password }
  describe "validate presence of password" do
    it "is invalid with a blank password" do
      user = FactoryBot.build(:user, password: " " * 6)
      expect(user).not_to be_valid
    end
    #passwordが5文字以下なら無効なこと
    it { should validate_length_of(:password).is_at_least(6)}
  end
  
end
