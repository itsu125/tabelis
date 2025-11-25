document.addEventListener("turbo:load", () => {
  const tagWrappers = document.querySelectorAll("#search-panel label");

  tagWrappers.forEach(wrapper => {
    const checkbox = wrapper.querySelector("input[type='checkbox']");
    const pill     = wrapper.querySelector("span");

    if (!checkbox || !pill) return;

    // ▼ 初期表示（checked → 固定カラー / 未選択 → グレー）
    if (checkbox.checked) {
      pill.className = `px-2 py-1 rounded-full text-xs border border-t-border whitespace-nowrap ${pill.dataset.colorClass}`;
    } else {
      pill.className = "px-2 py-1 rounded-full text-xs border border-gray-300 whitespace-nowrap bg-gray-200 text-gray-700";
    }

    // ▼ クリック時の切替
    wrapper.addEventListener("click", (e) => {
      e.preventDefault(); // label のクリックで即チェックされるのを防ぐ

      checkbox.checked = !checkbox.checked;

      if (checkbox.checked) {
        // 選択 → 固定カラー
        pill.className = `px-2 py-1 rounded-full text-xs border border-t-border whitespace-nowrap ${pill.dataset.colorClass}`;
      } else {
        // 解除 → グレー
        pill.className = "px-2 py-1 rounded-full text-xs border border-gray-300 whitespace-nowrap bg-gray-200 text-gray-700";
      }
    });
  });
});
