function setupNewTagCancel() {
  const buttons = document.querySelectorAll("[data-close-new-tag-form='true']");
  if (!buttons.length) return;

  buttons.forEach((btn) => {
    // 二重でイベントが発火するのを防ぐため一旦リセット
    btn.removeEventListener("click", handleClick);
    btn.addEventListener("click", handleClick);
  });
}

function handleClick(e) {
  e.preventDefault();
  // モーダルの中身を空にする
  const frame = document.getElementById("new_tag_form");
  if (frame) {
    frame.innerHTML = "";
  }
}

document.addEventListener("turbo:load", () => {
  setupNewTagCancel();
});

document.addEventListener("turbo:frame-load", (event) => {
  if (event.target.id === "new_tag_form") {
    setupNewTagCancel();
  }
});
