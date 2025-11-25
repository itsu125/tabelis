document.addEventListener("turbo:load", () => {
  const tagButtons = document.querySelectorAll(".tag-pill");

  tagButtons.forEach(button => {
    const tagColor = button.dataset.tagColor; // ← 追加

    button.addEventListener("click", () => {
      const tagId = button.dataset.tagId;
      const hiddenInputName = `shop[tag_ids][]`;
      const existingInput = document.querySelector(`input[name='${hiddenInputName}'][value='${tagId}']`);

      if (existingInput) {
        // 選択解除
        existingInput.remove();

        button.style.backgroundColor = "";       // 色解除
        button.style.color = "";                // 色解除
        button.classList.remove("text-white");
        button.classList.add("bg-gray-200", "text-gray-700", "border-gray-300");
      } else {
        // 選択
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = hiddenInputName;
        input.value = tagId;
        document.querySelector("form").appendChild(input);

        button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");

        // ここで固有カラーを適用
        button.style.backgroundColor = tagColor;
        button.style.color = "#442e18";  // tabelis の濃い茶色
        button.classList.add("border-t-border");
      }
    });
  });
});
