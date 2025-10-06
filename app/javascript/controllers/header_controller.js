import { Controller } from "@hotwired/stimulus"

// ハンバーガーメニューの開閉機能をStimulusコントローラーとして実装
export default class extends Controller {
  static targets = ["nav", "hamburger"]

  connect() {
    // メニュー外をクリックした時にメニューを閉じる
    this.boundCloseOnOutsideClick = this.closeOnOutsideClick.bind(this)
    this.boundCloseOnResize = this.closeOnResize.bind(this)

    document.addEventListener('click', this.boundCloseOnOutsideClick)
    window.addEventListener('resize', this.boundCloseOnResize)
  }

  disconnect() {
    document.removeEventListener('click', this.boundCloseOnOutsideClick)
    window.removeEventListener('resize', this.boundCloseOnResize)
  }

  toggle(event) {
    event.preventDefault()

    // ハンバーガーメニューボタンのアクティブ状態を切り替え
    this.hamburgerTarget.classList.toggle('active')

    // ナビゲーションメニューの表示/非表示を切り替え
    this.navTarget.classList.toggle('active')

    // アクセシビリティのためのaria-label更新
    const isActive = this.hamburgerTarget.classList.contains('active')
    this.hamburgerTarget.setAttribute('aria-label', isActive ? 'メニューを閉じる' : 'メニューを開く')
  }

  closeOnOutsideClick(event) {
    if (!this.navTarget || !this.hamburgerTarget) return

    const isClickInsideMenu = this.navTarget.contains(event.target)
    const isClickOnHamburger = this.hamburgerTarget.contains(event.target)

    if (!isClickInsideMenu && !isClickOnHamburger && this.navTarget.classList.contains('active')) {
      this.close()
    }
  }

  closeOnResize() {
    // デスクトップサイズになった時はメニューを閉じる
    if (window.innerWidth > 768) {
      this.close()
    }
  }

  close() {
    if (!this.navTarget || !this.hamburgerTarget) return

    this.hamburgerTarget.classList.remove('active')
    this.navTarget.classList.remove('active')
    this.hamburgerTarget.setAttribute('aria-label', 'メニューを開く')
  }
}
