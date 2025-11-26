require 'rails_helper'

RSpec.describe ShopTag, type: :model do
  describe "バリデーション" do
    it "有効なファクトリを持つこと" do
      shop_tag = build(:shop_tag)
      expect(shop_tag).to be_valid
    end

    it "shopが必須であること" do
      shop_tag = build(:shop_tag, shop: nil)
      expect(shop_tag).to be_invalid
      expect(shop_tag.errors[:shop]).to be_present
    end

    it "tagが必須であること" do
      shop_tag = build(:shop_tag, tag: nil)
      expect(shop_tag).to be_invalid
      expect(shop_tag.errors[:tag]).to be_present
    end
  end

  describe "アソシエーション" do
    it "shopに属すること" do
      association = described_class.reflect_on_association(:shop)
      expect(association.macro).to eq :belongs_to
    end

    it "tagに属すること" do
      association = described_class.reflect_on_association(:tag)
      expect(association.macro).to eq :belongs_to
    end
  end
end