class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    # 行きたい/行った の統計
    @want_count = current_user.shops.where(status: "want").count
    @went_count = current_user.shops.where(status: "went").count

    # 最近追加したショップ 3件
    @recent_shops = current_user.shops.order(created_at: :desc).limit(3)
  end
end
