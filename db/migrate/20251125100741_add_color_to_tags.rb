class AddColorToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :color, :string
  end
end
