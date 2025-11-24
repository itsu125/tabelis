document.addEventListener("turbo:load", () => {
  const input = document.getElementById("icon_input");
  if (!input) return;

  const fileName = document.getElementById("icon_file_name");
  const preview = document.getElementById("icon_preview");

  input.addEventListener("change", (event) => {
    const file = event.target.files[0];

    // ファイル名
    fileName.textContent = file ? file.name : "";

    if (!file) {
      preview.classList.add("hidden");
      preview.src = "#";
      return;
    }

    // プレビュー表示
    const reader = new FileReader();
    reader.onload = (e) => {
      preview.src = e.target.result;
      preview.classList.remove("hidden");
    };
    reader.readAsDataURL(file);
  });
});
