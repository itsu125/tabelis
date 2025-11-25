document.addEventListener("turbo:load", () => {
  const tagButtons = document.querySelectorAll(".tag-pill");

  tagButtons.forEach(button => {
    const tagId = button.dataset.tagId;
    const tagColor = button.dataset.tagColor;
    const hiddenInputName = `shop[tag_ids][]`;

    const isSelected = !!document.querySelector(
      `input[name='${hiddenInputName}'][value='${tagId}']`
    );

    // ▼ 初期表示（新規：灰色 / 編集：固定カラー）
    if (isSelected) {
      button.style.backgroundColor = tagColor;
      button.style.color = "var(--t-dark)";
      button.style.borderColor = tagColor;
    } else {
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
        button.style.backgroundColor = "";
        button.style.color = "var(--t-dark)";
        button.style.borderColor = "";
        button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
        button.classList.add("bg-gray-200", "text-gray-700", "border-gray-300");

      } else {
        // 選択 → 固定カラーにする
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = hiddenInputName;
        input.value = tagId;
        document.querySelector("form").appendChild(input);

        button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
        button.style.backgroundColor = tagColor;
        button.style.color = "var(--t-dark)";
        button.style.borderColor = tagColor;
      }
    });
  });
});
