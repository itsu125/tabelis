class ShopsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分が登録したショップ一覧
    @shops = current_user.shops.order(created_at: :desc)
  end
end
