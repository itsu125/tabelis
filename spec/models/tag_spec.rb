require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "バリデーション" do
    it "有効なファクトリを持つこと" do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it "nameが必須であること" do
      tag = build(:tag, name: nil)
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end

    it "nameが一意であること" do
      create(:tag, name: "ランチ")
      tag = build(:tag, name: "ランチ")
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end
  end

  describe "アソシエーション" do
    it "shop_tagsを複数持つこと" do
      association = described_class.reflect_on_association(:shop_tags)
      expect(association.macro).to eq :has_many
    end

    it "shopsと多対多であること（through: shop_tags）" do
      association = described_class.reflect_on_association(:shops)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :shop_tags
    end
  end
end