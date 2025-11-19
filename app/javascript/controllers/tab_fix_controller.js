import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // UMD版なので window.bootstrap が存在する
    this.element.querySelectorAll('[data-bs-toggle="tab"]').forEach(el => {
      new bootstrap.Tab(el)
    })

    // 初回表示も確実にアクティブにする
    const active = this.element.querySelector('.nav-link.active')
    if (active) bootstrap.Tab.getOrCreateInstance(active).show()
  }
}