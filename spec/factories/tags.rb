FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "タグ#{n}" }
    color       { '#ffffff' }
    color_class { 'bg-tag-sample' }
  end
end
