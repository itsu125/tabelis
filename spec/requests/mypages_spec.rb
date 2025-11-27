require 'rails_helper'

RSpec.describe 'Mypages', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:want_shops) { create_list(:shop, 2, user: user, status: :want) }
  let!(:went_shops) { create_list(:shop, 3, user: user, status: :went) }
  let!(:other_user_shop) { create(:shop, user: other_user, status: :want) }

  describe 'GET /mypage' do
    context 'ログイン済みの場合' do
      before do
        sign_in user
        get mypage_path
      end

      it '正常にレスポンスが返ってくる' do
        expect(response).to have_http_status(:success)
      end

      it '@userにcurrent_userがセットされている' do
        expect(assigns(:user)).to eq user
      end

      it '@want_count / @went_countが正しく集計されている' do
        expect(assigns(:want_count)).to eq 2
        expect(assigns(:went_count)).to eq 3
      end

      it '@recent_shopsはcurrent_userのショップから最大3件である' do
        recent_shops = assigns(:recent_shops)

        expect(recent_shops.size).to be <= 3
        expect(recent_shops.pluck(:user_id).uniq).to eq [user.id]
        expect(recent_shops).not_to include(other_user_shop)
      end
    end

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされる' do
        get mypage_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
