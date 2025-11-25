class SetDefaultTagColors < ActiveRecord::Migration[7.1]
  def up
    default_colors = {
      "ひとりで"     => "#A8D5BA",
      "友達と"       => "#F7E39C",
      "家族で"       => "#F7B2AD",
      "記念日に"     => "#CDB4DB",
      "ランチ"       => "#A3CEF1",
      "ディナー"     => "#7BA6DE",
      "テイクアウト" => "#F6C7C3"
    }

    default_colors.each do |name, color|
      tag = Tag.find_by(name: name)
      next unless tag
      tag.update!(color: color)
    end
  end

  def down
  end
end