import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  validateFile(event) {
    const file = event.target.files[0]
    if (file && !file.name.toLowerCase().endsWith('.xlsx')) {
      event.target.value = ''
      alert('Please select an XLSX file')
    }
  }
} 