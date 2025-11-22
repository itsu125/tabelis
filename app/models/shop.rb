class Shop < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # 行きたい / 行った
  enum status: { want: 0, went: 1 }

  # バリデーション
  validates :name, presence: true
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }
end
