class ShopsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分が登録したショップ一覧
    @shops = current_user.shops.order(created_at: :desc)
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.shops.new(shop_params)
    if @shop.save
      redirect_to shops_path, notice: 'リストに追加しました🌰'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :url, :address, :memo, :status, :image, :rating)
  end
end
