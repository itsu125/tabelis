class SetDefaultTagColorClasses < ActiveRecord::Migration[7.1]
  def up
    mapping = {
      "ひとりで"     => "bg-tag-hitori",
      "友達と"       => "bg-tag-friends",
      "家族で"       => "bg-tag-family",
      "記念日に"     => "bg-tag-memory",
      "ランチ"       => "bg-tag-lunch",
      "ディナー"     => "bg-tag-dinner",
      "テイクアウト" => "bg-tag-takeout"
    }

    mapping.each do |name, class_name|
      tag = Tag.find_by(name: name)
      next unless tag
      tag.update!(color_class: class_name)
    end
  end

  def down
  end
end
