console.log("map.js 読み込まれました");
// Google Maps の初期化関数
function initMap() {
  console.log("initMap が呼ばれました！");
  // 1. 地図の中心座標（とりあえず東京駅）,id="map" の要素を取得
  const center = { lat: 35.681236, lng: 139.767125 };
  const mapElement = document.getElementById("map");
  if (!mapElement) return; // map用の箱がなければ何もしない

  // Map インスタンスを作成（ここで地図が描画される）
  const map = new google.maps.Map(mapElement, {
    center: center,
    zoom: 14,
  });

  // 中心にピン（マーカー）を立てる
  new google.maps.Marker({
    position: center,
    map: map,
    title: "東京駅（仮ピン）",
  });
}

// Turbo がロードされたときに initMap を呼び出す
document.addEventListener("turbo:load", () => {
  console.log("turbo:load → initMap を呼び出します");

  // Google Maps API が読み込まれているか確認
  if (window.google && google.maps) {
    initMap();
  } else {
    console.warn("Google Maps API が読み込まれていません！");
  }
});