class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @favorite = current_user.favorites.create!(favorite_params)
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy
  end

  private

  def favorite_params
    params.require(:favorite).permit(:shop_id)
  end
end
