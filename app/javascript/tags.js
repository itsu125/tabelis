function setupTagButtons() {
  const container = document.getElementById("tag-select");
  if (!container) return;

  const hiddenInputName = "shop[tag_ids][]";
  const form = container.closest("form");
  if (!form) return;

  // 二重バインド防止
  if (container.dataset.tagsBound === "1") return;
  container.dataset.tagsBound = "1";

  // 初期表示（既に選択されているtag_idsに応じて色を合わせる）
  const buttons = container.querySelectorAll(".tag-pill");

  buttons.forEach((button) => {
    const tagId = button.dataset.tagId;
    const colorClass = button.dataset.tagColorClass;
    if (!tagId || !colorClass) return;

    const selector = `input[name='${hiddenInputName}'][value='${tagId}']`;
    const existingInput = form.querySelector(selector);

    if (existingInput) {
      // 選択済 → カラー表示
      button.classList.add(colorClass);
      button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
    } else {
      // 未選択 → グレー
      button.classList.add("bg-gray-200", "text-gray-700", "border-gray-300");
    }
  });

  // イベント委譲でクリック処理を設定
  container.addEventListener("click", (event) => {
    const button = event.target.closest(".tag-pill");
    if (!button || !container.contains(button)) return;

    const tagId = button.dataset.tagId;
    const colorClass = button.dataset.tagColorClass;
    if (!tagId || !colorClass) return;

    const selector = `input[name='${hiddenInputName}'][value='${tagId}']`;
    const existingInput = form.querySelector(selector);

    if (existingInput) {
      // 解除 → グレーに戻す
      existingInput.remove();
      button.classList.remove(colorClass);
      button.classList.add("bg-gray-200", "text-gray-700", "border-gray-300");
    } else {
      // 選択 → hidden を追加 & カラー表示
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = hiddenInputName;
      input.value = tagId;
      form.appendChild(input);

      button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
      button.classList.add(colorClass);  
    }
  });
}

// ページ初回読み込み時
document.addEventListener("turbo:load", () => {
  setupTagButtons();
});
// tag-list フレームが Turbo Stream で差し替えられた時
document.addEventListener("turbo:frame-load", (event) => {
  if (event.target.id === "tag-list") {
    setupTagButtons();
  }
});
