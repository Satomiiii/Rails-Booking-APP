// app/javascript/packs/application.js

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

// （必要なら）Bootstrap / jQuery を使う場合はコメントアウトを外す
// import "bootstrap";
// import $ from "jquery";
// window.$ = $;

Rails.start();
Turbolinks.start();
ActiveStorage.start();

// UJS が読み込まれているかの簡易確認（開発用）
window.__UJS_LOADED__ = !!Rails;

// ユーザーメニューの簡易ドロップダウン
document.addEventListener("turbolinks:load", () => {
  const toggle = document.getElementById("dropdownMenuLink");
  const menu   = document.getElementById("dropdownMenu");
  if (!toggle || !menu) return;

  // 初期は閉じる
  menu.classList.remove("show");

  // クリックで開閉
  const onToggleClick = (e) => {
    e.preventDefault();
    e.stopPropagation();
    menu.classList.toggle("show");
  };
  toggle.addEventListener("click", onToggleClick);

  // メニュー外クリックで閉じる
  const onDocClick = (e) => {
    if (!toggle.contains(e.target) && !menu.contains(e.target)) {
      menu.classList.remove("show");
    }
  };
  document.addEventListener("click", onDocClick);

  // ESCキーで閉じる
  const onKeyDown = (e) => {
    if (e.key === "Escape") menu.classList.remove("show");
  };
  document.addEventListener("keydown", onKeyDown);

  // Turbolinksキャッシュに入る前に閉じる
  document.addEventListener("turbolinks:before-cache", () => {
    menu.classList.remove("show");
  }, { once: true });
});
