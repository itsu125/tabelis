class AddCategoryIdToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :category_id, :integer
  end
end
