import React from 'react'
import { createRoot } from 'react-dom/client'
import PayTypeSelector from 'PayTypeSelector'

document.addEventListener('turbolinks:load', function() {
  const element = document.getElementById('pay-type-component')
  createRoot(element).render(<PayTypeSelector />)
})
