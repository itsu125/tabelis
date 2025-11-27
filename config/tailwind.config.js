module.exports = {
  content: [
    "./app/views/**/*.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      safelist: [
        "bg-tag-hitori",
        "bg-tag-friends",
        "bg-tag-family",
        "bg-tag-memory",
        "bg-tag-lunch",
        "bg-tag-dinner",
        "bg-tag-takeout",

        // ロゴ画像
        "w-16", "h-16",

        // 共通ヘッダー
        "w-10", "h-10",

        // マイページアイコン
        "w-24", "h-24",
      ],
    },
  },
  plugins: [],
}