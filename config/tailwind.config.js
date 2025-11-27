module.exports = {
  content: [
    "./app/views/**/*.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  safelist: [
    "bg-tag-hitori",
    "bg-tag-friends",
    "bg-tag-family",
    "bg-tag-memory",
    "bg-tag-lunch",
    "bg-tag-dinner",
    "bg-tag-takeout",
     // トップページのロゴ画像用
    "w-16",
    "h-16",
    "rounded-full",
    "object-cover",
    "flex-shrink-0",
    // 共通ヘッダーのロゴ画像用
    "w-10",
    "h-10",
  ],
  theme: {},
  plugins: [],
}