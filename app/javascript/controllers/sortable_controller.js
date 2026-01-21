import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "handle"]
  static classes = ["dragging"]

  connect() {
    this.draggedElement = null
    this.draggedIndex = null
  }

  dragstart(event) {
    this.draggedElement = event.currentTarget
    this.draggedIndex = this.itemTargets.indexOf(this.draggedElement)
    
    event.target.style.opacity = '0.5'
    event.dataTransfer.effectAllowed = 'move'
    event.dataTransfer.setData('text/html', event.target.innerHTML)
    
    this.draggedElement.classList.add(this.draggingClass)
  }

  dragend(event) {
    event.target.style.opacity = ''
    this.draggedElement.classList.remove(this.draggingClass)
  }

  dragover(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = 'move'
    
    const afterElement = this.getDragAfterElement(event.currentTarget.parentNode, event.clientY)
    if (afterElement == null) {
      event.currentTarget.parentNode.appendChild(this.draggedElement)
    } else {
      event.currentTarget.parentNode.insertBefore(this.draggedElement, afterElement)
    }
  }

  drop(event) {
    event.preventDefault()
    
    const newIndex = this.itemTargets.indexOf(this.draggedElement)
    if (newIndex !== this.draggedIndex) {
      this.updatePositions()
    }
  }

  getDragAfterElement(container, y) {
    const draggableElements = [...container.querySelectorAll('[data-sortable-target="item"]:not(.dragging)')]
    
    return draggableElements.reduce((closest, child) => {
      const box = child.getBoundingClientRect()
      const offset = y - box.top - box.height / 2
      
      if (offset < 0 && offset > closest.offset) {
        return { offset: offset, element: child }
      } else {
        return closest
      }
    }, { offset: Number.NEGATIVE_INFINITY }).element
  }

  updatePositions() {
    const positions = {}
    this.itemTargets.forEach((item, index) => {
      const todoId = item.dataset.todoId
      positions[todoId] = index
    })

    this.updateServer(positions)
  }

  updateServer(positions) {
    const formData = new FormData()
    formData.append('positions', JSON.stringify(positions))
    
    fetch('/todos/update_positions', {
      method: 'PATCH',
      body: formData,
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      if (data.success) {
        console.log('Positions updated successfully')
        this.showNotification('Todo order updated successfully!', 'success')
      } else {
        console.error('Failed to update positions:', data.error)
        this.showNotification('Failed to update todo order', 'error')
      }
    })
    .catch(error => {
      console.error('Error updating positions:', error)
      this.showNotification('Error updating todo order', 'error')
    })
  }

  showNotification(message, type = 'info') {
    // Remove any existing notifications
    const existingNotification = document.querySelector('.sortable-notification')
    if (existingNotification) {
      existingNotification.remove()
    }

    // Create new notification
    const notification = document.createElement('div')
    notification.className = `sortable-notification fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 transition-all duration-300 transform translate-x-full`
    
    if (type === 'success') {
      notification.classList.add('bg-green-500', 'text-white')
    } else if (type === 'error') {
      notification.classList.add('bg-red-500', 'text-white')
    } else {
      notification.classList.add('bg-blue-500', 'text-white')
    }
    
    notification.textContent = message
    document.body.appendChild(notification)
    
    // Animate in
    setTimeout(() => {
      notification.classList.remove('translate-x-full')
      notification.classList.add('translate-x-0')
    }, 100)
    
    // Remove after 3 seconds
    setTimeout(() => {
      notification.classList.add('translate-x-full')
      setTimeout(() => notification.remove(), 300)
    }, 3000)
  }
}