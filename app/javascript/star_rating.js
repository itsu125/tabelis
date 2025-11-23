document.addEventListener("turbo:load", () => {
  const stars = document.querySelectorAll("[data-star]");
  const ratingInput = document.querySelector("#shop_rating");

  if (!stars.length || !ratingInput) return; // 対象がなければ何もしない

  // 初期表示：既に評価が入っていれば反映
  const currentRating = parseInt(ratingInput.value || "0", 10);
  highlightStars(currentRating);

  // ★をクリックしたときの処理
  stars.forEach((star) => {
    star.addEventListener("click", () => {
      const rating = parseInt(star.dataset.star);
      ratingInput.value = rating;       // hidden_field にセット
      highlightStars(rating);           // ★の表示を更新
    });
  });

  // ★の見た目切り替え
  function highlightStars(rating) {
    stars.forEach((star) => {
      const starValue = parseInt(star.dataset.star);
      if (starValue <= rating) {
        star.classList.add("text-yellow-400");
        star.classList.remove("text-gray-300");
      } else {
        star.classList.add("text-gray-300");
        star.classList.remove("text-yellow-400");
      }
    });
  }
});
