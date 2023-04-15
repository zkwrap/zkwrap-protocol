import '../styles/globals.css'
import { ZKContractProvider } from '../Context/context'
export default function App({ Component, pageProps }) {
  return (
    <ZKContractProvider>
      <Component {...pageProps} />
    </ZKContractProvider>
  )
}
