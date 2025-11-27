FactoryBot.define do
  factory :shop do
    association :user
    association :category

    name    { Faker::Restaurant.name }
    url     { Faker::Internet.url }
    address { Faker::Address.full_address }
    memo    { Faker::Lorem.sentence }

    status  { :want }
    rating  { 3 }
  end
end
