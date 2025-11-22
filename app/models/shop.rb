class Shop < ApplicationRecord
  belongs_to :user

  # 行きたい / 行った
  enum status: { want: 0, went: 1 }

  # 店名のみ必須
  validates :name, presence: true
end
