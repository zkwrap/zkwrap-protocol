import './App.css'

import { Routes, Route } from 'react-router-dom'
import { Airdrop, Home, Pools, Rewards, Swap } from './pages'
import { Main } from './components'

function App() {

  return (
    <div className="App">
        <main>
          <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/main" element={<Main />}>
                <Route path="pools" element={<Pools /> } />
                <Route path="swap" element={<Swap /> } />
                <Route path="rewards" element={<Rewards /> } />
                <Route path="airdrop" element={<Airdrop /> } />
              </Route>
          </Routes>
        </main>
    </div>
  )
}

export default App
