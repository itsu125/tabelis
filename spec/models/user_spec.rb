require 'rails_helper'

RSpec.describe User, type: :model do
  describe "ユーザー新規登録" do
    it "有効なファクトリを持つこと" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "nameが必須であること" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end

    it "nameは30文字以内であること" do
      user = build(:user, name: "あ" * 31)
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end

    it "emailが必須であること" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it "emailが一意であること" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it "passwordが必須であること" do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to be_present
    end

    it "passwordとpassword_confirmationが一致していること" do
      user = build(:user, password: "password", password_confirmation: "111111")
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to be_present
    end

    it "passwordは6文字以上であること" do
      user = build(:user, password: "12345", password_confirmation: "12345")
      expect(user).to be_invalid
      expect(user.errors[:password]).to be_present
    end
  end

  describe "アソシエーション" do
    it "shopsを複数持てること" do
      association = described_class.reflect_on_association(:shops)
      expect(association.macro).to eq :has_many
    end

    it "iconを1つ添付できること" do
      expect(User.new).to respond_to(:icon)
    end
  end
end
