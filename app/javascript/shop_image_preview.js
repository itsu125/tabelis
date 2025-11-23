document.addEventListener("turbo:load", () => {
  const fileInput = document.getElementById("file_input");
  const fileName = document.getElementById("file_name");
  const preview = document.getElementById("image_preview");

  if (!fileInput) return;

  fileInput.addEventListener("change", (event) => {
    const file = event.target.files[0];

    // ファイル名を表示
    fileName.textContent = file ? file.name : "";

    // 画像プレビュー
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        preview.src = e.target.result;
        preview.classList.remove("hidden");
      };
      reader.readAsDataURL(file);
    } else {
      preview.classList.add("hidden");
      preview.src = "";
    }
  });
});
