class AddRatingToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :rating, :integer, null: false, default: 0
  end
end
