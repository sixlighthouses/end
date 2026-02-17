import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "content", "icon"]
  static values = {
    target: String
  }

  connect() {
    // Content is already hidden by default via the 'hidden' class
  }

  toggle(event) {
    const targetSelector = this.element.dataset.target
    const targetElement = document.querySelector(targetSelector)

    if (!targetElement) return

    targetElement.classList.toggle('hidden')

    const icon = this.element.querySelector('[data-accordion-toggle-target="icon"]')
    if (icon) {
      icon.classList.toggle('rotate-180')
    }
  }

  hide() {
    const targetSelector = this.element.dataset.target
    const targetElement = document.querySelector(targetSelector)
    
    if (targetElement) {
      targetElement.classList.add('hidden')
    }

    const icon = this.element.querySelector('[data-accordion-toggle-target="icon"]')
    if (icon) {
      icon.classList.remove('rotate-180')
    }
  }
}