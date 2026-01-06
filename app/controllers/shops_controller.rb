class ShopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:show, :edit, :update, :destroy]

  def index
    @status = params[:status] || 'want' # デフォルトは「行きたい」
    @categories = Category.all
    # Ransack 検索オブジェクト作成（current_user.shops を対象にする）
    @q = current_user.shops.ransack(params[:q])
    # ソート指定がない場合は、登録が新しい順に設定
    @q.sorts = "created_at desc" if @q.sorts.empty?
    # 検索結果を取得
    @shops = @q.result(distinct: true)

    # --- お気に入り絞り込み ---
    if params[:q]&.dig(:favorited) == "1"
      @shops = @shops.favorited_by(current_user)
    end

    # --- タグ絞り込み（複数 OR 条件） ---
    if params[:tags].present?
      @shops = @shops.joins(:tags).where(tags: { id: params[:tags] }).distinct
    end

    # --- 緯度経度が存在する店舗のみ取得 ---
    @shops_with_location = @shops.where.not(latitude: nil, longitude: nil)
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
