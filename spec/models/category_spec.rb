require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "バリデーション" do
    it "有効なファクトリを持つこと" do
      category = build(:category)
      expect(category).to be_valid
    end

    it "nameが必須であること" do
      category = build(:category, name: nil)
      expect(category).to be_invalid
      expect(category.errors[:name]).to be_present
    end

    it "nameが一意であること" do
      create(:category, name: "カフェ")
      category = build(:category, name: "カフェ")
      expect(category).to be_invalid
      expect(category.errors[:name]).to be_present
    end
  end

  describe "アソシエーション" do
    it "shopsを複数持てること" do
      association = described_class.reflect_on_association(:shops)
      expect(association.macro).to eq :has_many
    end
  end
end