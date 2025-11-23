class ShopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop, only: [:show, :edit, :update]
  before_action :authorize_user!, only: [:show, :edit, :update]

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

  def show
    @shop = Shop.find(params[:id])
  end

  def edit
  end

  def update
    if @shop.update(shop_params)
      redirect_to @shop, notice: '更新しました🌰'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  # 他ユーザーのURL直打ち対策
  def authorize_user!
    redirect_to shops_path, alert: "アクセスできません。" unless @shop.user_id == current_user.id
  end

  def shop_params
    params.require(:shop).permit(:name, :url, :address, :memo, :status, :image, :rating)
  end
end
