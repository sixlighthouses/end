import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "content"]
  static values = {
    target: String
  }

  connect() {
    // Initially hide all accordion panels
    const targetSelector = this.element.dataset.target
    const targetElement = document.querySelector(targetSelector)
    if (targetElement) {
      targetElement.classList.add('hidden')
    }
  }

  toggle(event) {
    const targetSelector = this.element.dataset.target
    const targetElement = document.querySelector(targetSelector)

    if (!targetElement) return

    targetElement.classList.toggle('hidden')
  }

  // Method to hide the accordion panel
  hide() {
    const targetSelector = this.element.dataset.target
    const targetElement = document.querySelector(targetSelector)
    
    if (targetElement) {
      targetElement.classList.add('hidden')
    }
  }
}