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

function syncTagColorPills(root) {
  // rootが渡されなければdocument全体を対象にする
  const scope = root || document;
  let forms;

  // rootが<form>自体ならその1件だけを対象にする
  if (scope.tagName === "FORM") {
    forms = [scope];
  } else {
    // それ以外の場合は中のformを全て探す
    forms = scope.querySelectorAll("form");
  }

  forms.forEach((form) => {
    const pills = form.querySelectorAll(".tag-color-pill");
    if (!pills.length) return;

    pills.forEach((pill) => {
      const colorClass = pill.dataset.colorClass;
      if (!colorClass) return;
      // nameがtag[color_class]でvalueがcolorclassのpillに対応するラジオボタンを探す
      const radio = form.querySelector(
        "input[type='radio'][name='tag[color_class]'][value='" + colorClass + "']"
      );
      if (!radio) return;

      if (radio.checked) {
        // ラジオが選択されている → カラーにする
        pill.dataset.selected = "true";
        pill.classList.remove("bg-gray-200", "text-gray-700", "border-gray-300");
        pill.classList.add(colorClass);
      } else {
        // ラジオが選択されていない →グレーにする
        pill.dataset.selected = "false";
        pill.classList.remove(colorClass);
        pill.classList.add("bg-gray-200", "text-gray-700", "border-gray-300");
      }
    });
  });
}

// カラー選択用のクリック処理
function setupTagColorPickerClick() {
  // 二重バインド防止
  if (document.body.dataset.tagColorPickerBound === "1") return;
  document.body.dataset.tagColorPickerBound = "1";

  // documentに対してイベント委譲
  document.addEventListener("click", function(event) {
    // クリック対象が.tag-color-pillが判定
    const pill = event.target.closest(".tag-color-pill");
    if (!pill) return;

    // labelによるラジオ自動ON/OFFを止める
    event.preventDefault();

    const form = pill.closest("form");
    if (!form) return;

    const colorClass = pill.dataset.colorClass;
    if (!colorClass) return;

    const radio = form.querySelector(
      "input[type='radio'][name='tag[color_class]'][value='" + colorClass + "']"
    );
    if (!radio) return;

    const radios = form.querySelectorAll(
      "input[type='radio'][name='tag[color_class]']"
    );

    // クリックされたpillのラジオがcheckedか
    if (radio.checked) {
      // 選択済み → 解除
      radio.checked = false;
    } else {
      // 選択された → 他を解除し、自分のみON
      radios.forEach(r => r.checked = false);
      radio.checked = true;
    }

    // ラジオ状態を見た目に反映
    syncTagColorPills(form);
  });
}

// ページ初回読み込み時
document.addEventListener("turbo:load", () => {
  setupTagButtons();
  setupTagColorPickerClick();
  syncTagColorPills(document);
});
// tag-list フレームが Turbo Stream で差し替えられた時
document.addEventListener("turbo:frame-load", (event) => {
  if (event.target.id === "tag-list") {
    setupTagButtons();
  }
  // new_tag_form フレームが差し替えられたらその中だけ同期
  if (event.target.id === "new_tag_form") {
    syncTagColorPills(event.target);
  }
});
