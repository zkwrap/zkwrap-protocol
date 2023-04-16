import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

import { ZkContextProvider } from "./Context"
import { BrowserRouter as Router } from 'react-router-dom'

import { ThirdwebProvider, ChainId } from "@thirdweb-dev/react";

const root = ReactDOM.createRoot(document.getElementById('root'))

root.render(
  <React.StrictMode>
        <ThirdwebProvider activeChain={ChainId.ArbitrumGoerli}>
          <ZkContextProvider >
              <Router>
                  <App />
              </Router> 
          </ZkContextProvider>
        </ThirdwebProvider>
  </React.StrictMode>,
)
