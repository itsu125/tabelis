class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :shops, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 30 }
end
