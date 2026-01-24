import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "content", "icon"]

  connect() {
    this.itemTargets.forEach(item => {
      const content = item.querySelector('[data-note-accordion-target="content"]')
      const icon = item.querySelector('[data-note-accordion-target="icon"]')
      if (content && icon) {
        content.classList.add('hidden')
        icon.classList.remove('rotate-180')
      }
    })
  }

  toggle(event) {
    if (event.target.closest('a')) return

    const item = event.currentTarget.closest('[data-note-accordion-target="item"]')
    const content = item.querySelector('[data-note-accordion-target="content"]')
    const icon = item.querySelector('[data-note-accordion-target="icon"]')

    if (!content || !icon) return

    const isExpanded = !content.classList.contains('hidden')

    if (isExpanded) {
      content.classList.add('hidden')
      icon.classList.remove('rotate-180')
    } else {
      content.classList.remove('hidden')
      icon.classList.add('rotate-180')
    }
  }
}