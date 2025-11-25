categories = [
  "和食",
  "洋食",
  "中華",
  "カフェ",
  "スイーツ",
  "ラーメン",
  "イタリアン",
  "韓国料理",
  "エスニック",
  "焼肉",
  "海鮮・寿司",
  "ファストフード"
]

categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end