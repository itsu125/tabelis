document.addEventListener("turbo:load", () => {
  const tabButtons = document.querySelectorAll(".tab-btn");
  const shopCards  = document.querySelectorAll(".shop-card");

  // 画面にタブやカードがない場合は何もしない
  if (tabButtons.length === 0 || shopCards.length === 0) return;

  // 初期ロードで「Activeになっているタブ」を取得
  let activeTab = document.querySelector(".tab-btn.text-t-primary");

  // Activeがなければwantをデフォルトに
  if (!activeTab) {
    activeTab = document.querySelector('[data-status="want"]');
  }

  // 初期ロード時にactiveタブと同じ処理を実行
  const applyFilter = (status) => {
    // ① タブデザインを切り替える
    tabButtons.forEach((btn) => {
      btn.classList.remove("text-t-primary", "border-b-2", "border-t-primary");
      btn.classList.add("text-t-text-mid");
    });

    const activeBtn = document.querySelector(`[data-status="${status}"]`);
    activeBtn.classList.add("text-t-primary", "border-b-2", "border-t-primary");
    activeBtn.classList.remove("text-t-text-mid");
    // ② カードの表示・非表示を切り替える
    shopCards.forEach((card) => {
      if (card.dataset.status === status) {
        card.style.display = "block";
      } else {
        card.style.display = "none";
      }
    });
  };

  // 初期ロードで適用
  applyFilter(activeTab.dataset.status);
  // タブクリック時の処理
  tabButtons.forEach((button) => {
    button.addEventListener("click", () => {
      applyFilter(button.dataset.status);
    });
  });
});