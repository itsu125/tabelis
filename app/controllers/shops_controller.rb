class ShopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:show, :edit, :update, :destroy]

  def index
    @status = params[:status] || 'want' # デフォルトは「行きたい」
    @categories = Category.all
    # Ransack 検索オブジェクト作成（current_user.shops を対象にする）
    @q = current_user.shops.ransack(params[:q])
    # 検索結果を取得し、作成日の降順で並び替え
    @shops = @q.result.order(created_at: :desc)

    # --- タグ絞り込み（複数 OR 条件） ---
    return if params[:tags].blank?

    @shops = @shops.joins(:tags).where(tags: { id: params[:tags] }).distinct
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

  def destroy
    if @shop.destroy
      redirect_to shops_path, notice: '削除しました🍂'
    else
      redirect_to shop_path(@shop), alert: '削除に失敗しました'
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  # 他ユーザーのURL直打ち対策
  def authorize_user!
    redirect_to shops_path, alert: 'アクセスできません。' unless @shop.user_id == current_user.id
  end

  def shop_params
    params.require(:shop).permit(:name, :url, :address, :memo, :status, :image, :rating, :category_id, tag_ids: [])
  end
end
