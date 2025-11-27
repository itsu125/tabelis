require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user, name: '元の名前') }

  describe 'GET /users/:id/edit' do
    context 'ログイン済みの場合' do
      before do
        sign_in user
      end

      it '自分の編集画面にアクセスできる' do
        get edit_user_path(user)
        expect(response).to have_http_status(:success)
      end

      it 'URLのidに関わらずcurrent_userが編集対象になる' do
        other_user = create(:user)

        get edit_user_path(other_user)
        expect(response).to have_http_status(:success)
        expect(assigns(:user)).to eq user # current_user がセットされる
      end
    end

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされる' do
        get edit_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH /users/:id' do
    before do
      sign_in user
    end

    context 'パラメータが有効な場合' do
      let(:valid_params) do
        { user: { name: '新しい名前' } }
      end

      it 'current_userのプロフィールが更新される' do
        patch user_path(user), params: valid_params

        expect(user.reload.name).to eq '新しい名前'
        expect(response).to redirect_to mypage_path
        expect(flash[:notice]).to eq 'プロフィールを更新しました'
      end

      it 'URLのidに他人を指定しても、更新されるのはcurrent_userのみ' do
        other_user = create(:user, name: '他人の名前')

        patch user_path(other_user), params: valid_params

        expect(user.reload.name).to eq '新しい名前'
        expect(other_user.reload.name).to eq '他人の名前'
      end
    end

    context 'パラメータが無効な場合' do
      let(:invalid_params) do
        { user: { name: '' } }
      end

      it '更新に失敗し、422（処理不可）が返る' do
        patch user_path(user), params: invalid_params

        expect(response).to have_http_status(422)
        expect(user.reload.name).to eq '元の名前'
      end
    end

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされる' do
        sign_out user

        patch user_path(user), params: { user: { name: '変更' } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
