class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name,    null: false         # 店名（必須）
      t.string :url                          # 任意：URL
      t.string :address                      # 任意：住所
      t.text   :memo                         # 任意：メモ（「友達と行く」など）

      # 行きたい / 行った の状態（enumで管理、後々中間テーブルへ移行の可能性）
      # want: 0, went: 1
      t.integer :status, null: false, default: 0

      # 地図連携用（後から使う予定）
      t.float :latitude                      # 緯度
      t.float :longitude                     # 経度

      t.timestamps
    end

    # 状態での絞り込み用（行きたい / 行った）
    add_index :shops, :status
  end
end
