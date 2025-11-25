document.addEventListener("turbo:load", () => {
  const tagButtons = document.querySelectorAll(".tag-pill");

  tagButtons.forEach((button) => {
    const tagId = button.dataset.tagId;
    const colorClass = button.dataset.tagColorClass; // ← color_class を利用
    const hiddenInputName = "shop[tag_ids][]";

    const existingInput = document.querySelector(
      `input[name='${hiddenInputName}'][value='${tagId}']`
    );

    // ▼ 初期表示（新規：灰色 / 編集：固定カラー）
    if (existingInput) {
      // 選択済 → カラー表示
      button.classList.add(colorClass);
      button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
    } else {
      // 未選択 → グレー
      button.classList.add("bg-gray-200", "text-gray-700", "border-gray-300");
    }

    // ▼クリック時の挙動
    button.addEventListener("click", () => {
      const existingInput = document.querySelector(
        `input[name='${hiddenInputName}'][value='${tagId}']`
      );

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
        document.querySelector("form").appendChild(input);

        button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
        button.classList.add(colorClass);
      }
    });
  });
});
