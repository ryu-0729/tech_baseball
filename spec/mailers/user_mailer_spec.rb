require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }

    #ユーザーのメールアドレスに送信すること
    it "sends a email to the user email" do
      expect(mail.to).to eq [user.email]
    end
    
    #サポート用のメールアドレスから送信すること
    it "sends from the support email address" do
      expect(mail.from).to eq ["support@example.com"]
    end
    
    #正しい件名で送信すること
    it "sends with the correct subject" do
      expect(mail.subject).to eq "Account activation"
    end
    
    #メールのプレビュー
    context "preview" do
      #ユーザーの名前
      it "user name" do
        expect(mail.body.encoded).to match user.name
      end
      #有効化トークン
      it "activation_token" do
        expect(mail.body.encoded).to match user.activation_token
      end
      #emailのエスケープ
      it "email" do
        expect(mail.body.encoded).to match CGI.escape(user.email)
      end
    end
    

    #it "renders the headers" do
      #expect(mail.subject).to eq("Account activation")
      #expect(mail.to).to eq(["to@example.org"])
      #expect(mail.from).to eq(["from@example.com"])
    #end

    #it "renders the body" do
      #expect(mail.body.encoded).to match("Hi")
    #end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["support@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
