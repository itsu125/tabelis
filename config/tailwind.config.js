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
    "w-16",
    "h-16",
    "w-12",
    "h-12",
    "w-10",
    "h-10",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}