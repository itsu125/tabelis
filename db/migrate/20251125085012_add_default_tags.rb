class AddDefaultTags < ActiveRecord::Migration[7.1]
  def up
    tags = [
      "ひとりで",
      "友達と",
      "家族で",
      "記念日に",
      "ランチ",
      "ディナー",
      "テイクアウト"
    ]

    tags.each do |tag_name|
      Tag.find_or_create_by!(name: tag_name)
    end
  end

  def down
  end
end
