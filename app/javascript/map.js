console.log("map.js 読み込まれました");
// マップ本体＆現在地マーカーの変数を空で宣言
let map;
let currentLocationMarker;

// Google Maps の初期化関数
function initMap() {
  console.log("initMap が呼ばれました！");
  // 1. 地図の中心座標（とりあえず東京駅）,id="map" の要素を取得
  const center = { lat: 35.681236, lng: 139.767125 };
  const mapElement = document.getElementById("map");
  // mapブロックがなければ何もしない
  if (!mapElement) {
    console.log("#map が存在しないため initMap を中断");
    return;
  }

  // マップオプションを変数に格納
  const mapOptions = {
    zoom: 15,
    center: center,
  };

  // Map インスタンスを作成（ここで地図が描画される）
  map = new google.maps.Map(mapElement, mapOptions);

  // 現在地取得
  if (navigator.geolocation) {

    // オプション設定(最大5秒待機、高精度OFF、最新位置のみ取得)
    const geoOptions = {
      timeout: 5000,
      enableHighAccuracy: false,
      maximumAge: 0,
    };

    // ショップデータを data-shops 属性から取得
    const shopsDataRaw = mapElement.dataset.shops;
    let shopsData = [];

    // JSONパース（中身が空配列の場合もあるので安全に処理）
    try {
      shopsData = JSON.parse(shopsDataRaw);
      console.log("ショップデータ読み込み成功", shopsData);
    } catch (e) {
      console.warn("ショップデータのパースに失敗しました:", e);
    }

    navigator.geolocation.getCurrentPosition(
      (pos) => {

        // 現在地の緯度・軽度を変数に格納
        let nowLat = pos.coords.latitude;
        let nowLng = pos.coords.longitude;
        // Google Maps 用の座標オブジェクト
        let nowLatLng = new google.maps.LatLng(nowLat, nowLng);
        let activeInfoWindow = null;

        console.log("現在地取得しました", nowLat, nowLng);

        // 地図の中心を現在地に移動
        map.setCenter(nowLatLng);
        map.setZoom(15);

        // 既存マーカーがあれば削除
        if (currentLocationMarker) {
          currentLocationMarker.setMap(null);
        }

        // 現在地にピンを立てる
        currentLocationMarker = new google.maps.Marker({
          position: nowLatLng,
          map: map,
          title: "現在地",
          icon: {
            url: "https://maps.google.com/mapfiles/ms/icons/red-dot.png",
          },
        });
        // ショップデータに基づいてピンを立てる
        shopsData.forEach((shop) => {
          const shopLat = shop.latitude;
          const shopLng = shop.longitude;
          // 距離計算
          const distance = calculateDistance(
            nowLat,
            nowLng,
            shopLat,
            shopLng
          );

          console.log(`${shop.name} までの距離: ${distance} km`);

          const distanceText =
            distance < 1
              ? `${Math.round(distance * 1000)} m`
              : `${distance.toFixed(1)} km`;

          // 対応するカードの距離表示要素を取得
          const distanceElement = document.querySelector(
            `[data-distance-for="${shop.id}"]`
          );
          // 要素が存在すれば距離を表示
          if (distanceElement) {
            distanceElement.textContent = `現在地から ${distanceText}`;
          }
          
          // マーカーの位置情報を作成
          const position = new google.maps.LatLng(shopLat, shopLng);

          const marker = new google.maps.Marker({
            position: position,
            map: map,
            title: shop.name,
            icon: {
              url: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png",
            },
          });

          // マーカークリック時に情報ウィンドウを表示
          const infoWindow = new google.maps.InfoWindow({
            headerContent: shop.name,
            content: `
              <div style="font-size:13px; line-height:1.4;">
                <div>${shop.address ?? "住所未登録"}</div>
                <div style="margin-top:4px; color:#555;">
                  現在地から ${distanceText}
                </div>
                <div style="margin-top:5px;">
                  <a href="/shops/${shop.id}"
                     style="color:#2563eb; text-decoration:underline;">
                     詳細を見る
                  </a>
                </div>
              </div>
            `,
          });
          // マーカークリックイベントを追加
          marker.addListener("click", () => {
            // 既存の情報ウィンドウがあれば閉じる
            if (activeInfoWindow) {
              activeInfoWindow.close();
            }
            // 新しい情報ウィンドウを開く
            infoWindow.open({
              anchor: marker,
              map,
              shouldFocus: false,
            });
            // 現在の情報ウィンドウを更新
            activeInfoWindow = infoWindow;
          });

          // 地図クリック時に情報ウィンドウを閉じる
          map.addListener("click", () => {
            if (activeInfoWindow) {
              activeInfoWindow.close();
              activeInfoWindow = null;
            }
          });
        });
      },
      (err) => {
        console.warn("現在地を取得できませんでした:", err);
      },
      geoOptions
    );
  } else {
    console.warn("このブラウザでは位置情報がサポートされていません");
  }
};

function calculateDistance(lat1, lng1, lat2, lng2) {
  const R = 6371; // 地球の半径（km）
  const toRad = (value) => value * Math.PI / 180;

  const dLat = toRad(lat2 - lat1);
  const dLng = toRad(lng2 - lng1);

const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) *
      Math.cos(toRad(lat2)) *
      Math.sin(dLng / 2) *
      Math.sin(dLng / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // 距離を km 単位で返す
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

  // 切り替えボタンとmapブロックの要素を取得
  const toggleButton = document.getElementById("toggle-map-button");
  const mapElement = document.getElementById("map");

  // どちらかが存在しないページでは何もしない
  if (!toggleButton || !mapElement) {
    console.log("toggleButton または mapElement が存在しないため、地図切り替え処理はスキップ");
    return;
  }

  // デフォルトは地図非表示
  mapElement.classList.add("hidden");

  // ボタンクリックされたときの処理
  toggleButton.addEventListener("click", () => {
    // hidden クラスの有無を調べる
    const isHidden = mapElement.classList.contains("hidden");

    if (isHidden) {
      // hidden クラスがある → 地図を表示する
      mapElement.classList.remove("hidden");

      // hidden クラスがない → 地図を非表示にする
    } else {
      mapElement.classList.add("hidden");
    }
  });
});