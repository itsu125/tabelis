document.addEventListener("turbo:load", () => {
  const toggleBtn = document.getElementById("search-toggle");
  const panel = document.getElementById("search-panel");
  const icon = document.getElementById("search-toggle-icon");

  if (!toggleBtn || !panel) return;

  toggleBtn.addEventListener("click", () => {
    const isHidden = panel.classList.contains("hidden");

    if (isHidden) {
      panel.classList.remove("hidden");
      setTimeout(() => {
        panel.classList.remove("opacity-0", "-translate-y-1");
      }, 10);
      icon.textContent = "▲";
    } else {
      panel.classList.add("opacity-0", "-translate-y-1");
      icon.textContent = "▼";
      setTimeout(() => panel.classList.add("hidden"), 200);
    }
  });
});
