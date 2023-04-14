import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

import { ZkContextProvider } from "./Context"
import { BrowserRouter as Router } from 'react-router-dom'

import { ThirdwebProvider } from "@thirdweb-dev/react";
import { ChainId } from "@thirdweb-dev/sdk"

const root = ReactDOM.createRoot(document.getElementById('root'))

root.render(
  <React.StrictMode>
      <ZkContextProvider>
          <ThirdwebProvider activeChain={ChainId.Goerli}>
            <Router>
              <App />
            </Router> 
          </ThirdwebProvider>
      </ZkContextProvider>
  </React.StrictMode>,
)
