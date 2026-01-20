class Tag < ApplicationRecord
  has_many :shop_tags, dependent: :destroy
  has_many :shops, through: :shop_tags
  belongs_to :user, optional: true

  validates :name, presence: true,
                   uniqueness: { scope: :user_id }

  def self.available_for(user)
    where(user_id: nil).or(where(user_id: user.id))
  end

  def self.color_options
    [
      ["グリーン系", "bg-tag-hitori"],
      ["イエロー系", "bg-tag-friends"],
      ["ピンク系", "bg-tag-family"],
      ["パープル系", "bg-tag-memory"],
      ["ライトブルー系", "bg-tag-lunch"],
      ["ブルー系", "bg-tag-dinner"],
      ["サーモン系", "bg-tag-takeout"],
    ]
  end

  COLOR_CLASS_LIST = color_options.map { |(_, class_name)| class_name }.freeze

  validates :color_class,
            presence: { message: "を選択してください" },
            inclusion: { in: COLOR_CLASS_LIST, allow_nil: true }
end
