class AddUserIdToTags < ActiveRecord::Migration[7.1]
  def change
    # nameのユニークインデックスを削除
    remove_index :tags, name: "index_tags_on_name"

    # user_idカラム追加、デフォルトタグはuser_idがnullのままで許可
    add_reference :tags, :user, foreign_key: true, null: true

    # nameとuser_idの複合ユニークインデックスを追加
    add_index :tags, [:name, :user_id], unique: true

  end
end
