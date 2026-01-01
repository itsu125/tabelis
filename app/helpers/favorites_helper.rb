module FavoritesHelper
  def favorite_for(shop)
    current_user&.favorites&.find_by(shop_id: shop.id)
  end
end
