import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

import { ZkContextProvider } from "./Context"
import { BrowserRouter as Router } from 'react-router-dom'

const root = ReactDOM.createRoot(document.getElementById('root'))

root.render(
  <React.StrictMode>
    <Router>
      <ZkContextProvider>
        <App />
      </ZkContextProvider>
    </Router> 
  </React.StrictMode>,
)
