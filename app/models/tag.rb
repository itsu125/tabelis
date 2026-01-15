class Tag < ApplicationRecord
  has_many :shop_tags, dependent: :destroy
  has_many :shops, through: :shop_tags
  belongs_to :user, optional: true

  validates :name, presence: true,
                   uniqueness: { scope: :user_id }

  def self.available_for(user)
    where(user_id: nil).or(where(user_id: user.id))
  end
end
