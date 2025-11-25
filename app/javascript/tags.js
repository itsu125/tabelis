document.addEventListener("turbo:load", () => {
  const tagButtons = document.querySelectorAll(".tag-pill");

  tagButtons.forEach(button => {
    button.addEventListener("click", () => {
      const tagId = button.dataset.tagId;
      const hiddenInputName = `shop[tag_ids][]`;
      const existingInput = document.querySelector(`input[name='${hiddenInputName}'][value='${tagId}']`);

      if (existingInput) {
        // 選択解除
        existingInput.remove();
        button.classList.remove("bg-t-primary", "text-white", "border-t-primary");
        button.classList.add("bg-gray-200", "text-gray-700", "border-gray-300");
      } else {
        // 選択
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = hiddenInputName;
        input.value = tagId;
        document.querySelector("form").appendChild(input);

        button.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
        button.classList.add("bg-t-primary", "text-white", "border-t-primary");
      }
    });
  });
});
