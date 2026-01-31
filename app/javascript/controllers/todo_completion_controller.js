import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "statusText"]

  toggle(event) {
    const checkbox = event.target
    const todoId = checkbox.dataset.todoId
    const url = checkbox.dataset.url
    const completed = checkbox.checked
    
    // Update the status text immediately for better UX
    this.updateStatusText(checkbox, completed)
    
    // Send the update to the server
    this.updateServer(url, completed, checkbox)
  }

  updateStatusText(checkbox, completed) {
    // Find the status text element next to the checkbox
    const statusText = checkbox.parentElement.querySelector('span')
    if (statusText) {
      statusText.textContent = completed ? "Completed" : "Pending"
      // Add visual feedback
      if (completed) {
        statusText.classList.add('text-green-600')
        statusText.classList.remove('text-gray-600')
      } else {
        statusText.classList.add('text-gray-600')
        statusText.classList.remove('text-green-600')
      }
    }
  }

  updateServer(url, completed, checkbox) {
    const formData = new FormData()
    formData.append('todo[completed]', completed)
    
    fetch(url, {
      method: 'PATCH',
      body: formData,
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': this.getCSRFToken()
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      console.log('Todo completion updated successfully')
      this.showNotification('Todo status updated successfully!', 'success')
    })
    .catch(error => {
      console.error('Error updating todo completion:', error)
      // Revert the checkbox state on error
      checkbox.checked = !checkbox.checked
      this.updateStatusText(checkbox, !checkbox.checked)
      this.showNotification('Failed to update todo status', 'error')
    })
  }

  getCSRFToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.getAttribute('content') : ''
  }

  showNotification(message, type = 'info') {
    // Remove any existing notifications
    const existingNotification = document.querySelector('.todo-completion-notification')
    if (existingNotification) {
      existingNotification.remove()
    }

    // Create new notification
    const notification = document.createElement('div')
    notification.className = `todo-completion-notification fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 transition-all duration-300 transform translate-x-full`
    
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