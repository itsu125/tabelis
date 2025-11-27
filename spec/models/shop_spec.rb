require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      shop = build(:shop)
      expect(shop).to be_valid
    end

    it 'nameが必須であること' do
      shop = build(:shop, name: nil)
      expect(shop).to be_invalid
      expect(shop.errors[:name]).to be_present
    end

    describe 'ratingのバリデーション' do
      it '整数であること' do
        shop = build(:shop, rating: 3.5)
        expect(shop).to be_invalid
        expect(shop.errors[:rating]).to be_present
      end

      it '0以上であること' do
        shop = build(:shop, rating: -1)
        expect(shop).to be_invalid
        expect(shop.errors[:rating]).to be_present
      end

      it '5以下であること' do
        shop = build(:shop, rating: 6)
        expect(shop).to be_invalid
        expect(shop.errors[:rating]).to be_present
      end

      it '0～5の範囲なら有効であること' do
        [0, 1, 2, 3, 4, 5].each do |valid_value|
          shop = build(:shop, rating: valid_value)
          expect(shop).to be_valid
        end
      end
    end
  end

  describe 'アソシエーション' do
    it 'userに属すること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'categoryに属すること（optional）' do
      association = described_class.reflect_on_association(:category)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to eq true
    end

    it 'shop_tagsを複数持つこと' do
      association = described_class.reflect_on_association(:shop_tags)
      expect(association.macro).to eq :has_many
    end

    it 'tagsと多対多であること（through: shop_tags）' do
      association = described_class.reflect_on_association(:tags)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :shop_tags
    end
  end

  describe 'enum' do
    it 'want/wentの2種類を持つこと' do
      expect(described_class.statuses.keys).to match_array %w[want went]
    end
  end

  describe '.ransackable_attributes' do
    it '検索可能なカラムを返すこと' do
      expect(described_class.ransackable_attributes).to match_array %w[
        name memo address url category_id status rating
        created_at updated_at
      ]
    end
  end

  describe '.ransackable_associations' do
    it '検索可能なアソシエーションを返すこと' do
      expect(described_class.ransackable_associations).to match_array %w[category tags]
    end
  end

  describe 'ActiveStorage' do
    it 'imageを添付できること' do
      shop = build(:shop)
      expect(shop).to respond_to(:image)
    end
  end
end
