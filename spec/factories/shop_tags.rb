FactoryBot.define do
  factory :shop_tag do
    association :shop
    association :tag
  end
end