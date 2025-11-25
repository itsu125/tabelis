class AddColorClassToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :color_class, :string
  end
end
