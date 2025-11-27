require 'rails_helper'

RSpec.describe 'Shops', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:category) { create(:category) }
  let(:tag1) { create(:tag) }
  let(:tag2) { create(:tag) }

  let!(:shop_want) { create(:shop, user: user, status: :want, name: 'カフェA') }
  let!(:shop_went) { create(:shop, user: user, status: :went, name: 'レストランB') }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'ログイン済みユーザーは正常にレスポンスが返ってくる' do
      get shops_path
      expect(response).to have_http_status(:success)
    end

    it 'デフォルトのステータスはwantである' do
      get shops_path
      expect(assigns(:status)).to eq 'want'
      expect(assigns(:shops)).to include(shop_want)
      expect(assigns(:shops)).not_to include(shop_went)
    end

    it 'status=wentの場合はwentの店舗が表示される' do
      get shops_path(status: 'went')
      expect(assigns(:shops)).to include(shop_went)
      expect(assigns(:shops)).not_to include(shop_want)
    end

    it 'フリーワード検索が機能する（カフェAを検索）' do
      get shops_path, params: { q: { name_or_memo_or_address_cont: 'カフェ' } }
      expect(assigns(:shops)).to include(shop_want)
      expect(assigns(:shops)).not_to include(shop_went)
    end

    it 'タグ絞り込みが機能する' do
      # shop_wantにtag1を付与
      shop_want.tags << tag1

      get shops_path, params: { tags: [tag1.id] }
      expect(assigns(:shops)).to include(shop_want)
      expect(assigns(:shops)).not_to include(shop_went)
    end

    it '検索+タブの複合が機能する' do
      create(:shop, user: user, status: :went, name: 'バーC')

      get shops_path, params: {
        status: 'went',
        q: { name_or_memo_or_address_cont: 'バー' }
      }

      found_shops = assigns(:shops).pluck(:name)
      expect(found_shops).to eq(['バーC'])
    end
  end

  describe 'GET /new' do
    it '成功する' do
      get new_shop_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    let(:valid_params) do
      {
        shop: {
          name: '新しい店',
          url: 'https://example.com',
          address: '東京都',
          memo: 'メモ',
          status: 'want',
          rating: 3,
          category_id: category.id,
          tag_ids: [tag1.id, tag2.id]
        }
      }
    end

    it '正しいパラメータで保存に成功するとshopが増える' do
      expect do
        post shops_path, params: valid_params
      end.to change(Shop, :count).by(1)
    end

    it 'current_userに紐づいて作成される' do
      post shops_path, params: valid_params
      expect(Shop.last.user_id).to eq(user.id)
    end

    it '不正パラメータでは保存できず、shopは増えない' do
      invalid_params = { shop: { name: '', rating: 3 } }

      expect do
        post shops_path, params: invalid_params
      end.not_to change(Shop, :count)

      expect(response).to have_http_status(422)
    end
  end

  describe 'GET /show' do
    it '自分のshopなら表示される' do
      get shop_path(shop_want)
      expect(response).to have_http_status(:success)
    end

    it '他人のshopはアクセスできない' do
      other_shop = create(:shop, user: other_user)

      get shop_path(other_shop)
      expect(response).to redirect_to(shops_path)
      expect(flash[:alert]).to eq('アクセスできません。')
    end
  end

  describe 'GET /edit' do
    it '自分のshopならアクセスできる' do
      get edit_shop_path(shop_want)
      expect(response).to have_http_status(:success)
    end

    it '他人のshopはアクセスできない' do
      other_shop = create(:shop, user: other_user)

      get edit_shop_path(other_shop)
      expect(response).to redirect_to(shops_path)
    end
  end

  describe 'PATCH /update' do
    it '更新に成功する' do
      patch shop_path(shop_want), params: {
        shop: { name: '更新後の名前' }
      }

      expect(shop_want.reload.name).to eq('更新後の名前')
      expect(response).to redirect_to(shop_path(shop_want))
    end

    it '更新に失敗した場合は422（処理不可）が返る' do
      patch shop_path(shop_want), params: {
        shop: { name: '' }
      }

      expect(response).to have_http_status(422)
    end

    it '他人のshopは更新できない' do
      other_shop = create(:shop, user: other_user)

      patch shop_path(other_shop), params: {
        shop: { name: '変更不可' }
      }

      expect(response).to redirect_to(shops_path)
    end
  end

  describe 'DELETE /destroy' do
    it '自分のshopは削除できる' do
      shop_delete = create(:shop, user: user)
      expect do
        delete shop_path(shop_delete)
      end.to change(Shop, :count).by(-1)
    end

    it '他人のshopは削除できない' do
      other_shop = create(:shop, user: other_user)

      expect do
        delete shop_path(other_shop)
      end.not_to change(Shop, :count)

      expect(response).to redirect_to(shops_path)
      expect(flash[:alert]).to eq('アクセスできません。')
    end
  end
end
