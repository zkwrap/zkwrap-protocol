import Header from "../Header"
import Footer from "../Footer"
import { Outlet } from "react-router-dom"
import Info from "../Info"

import { useZkContext } from "../../Context"

const Main = () => {
  const { darkTheme } = useZkContext()

  return (
    <div className={`bg-[#d0def1] h-[max-content] ${darkTheme ? "dark" : "light" }`}>
        <Info />
        <Header />  
            <Outlet />
        <Footer />
    </div>
  )
}

export default Main