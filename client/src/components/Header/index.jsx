import { navlinks } from "../../constants"
import { Link } from 'react-router-dom'
import { useZkContext } from '../../Context'

import Theme from "../Theme"

const Header = () => {
    const { darkTheme } = useZkContext()

  return (
    <div className={` ${darkTheme ? "dark" : "light" } h-[100px] sticky top-0 mb-[30px] w-full`}>

       <nav className='w-[100%] h-full flex justify-between dark:bg-third bg-[#d0def1] items-center mx-auto px-[50px]'>
          <h3 className="dark:text-textPrimary text-textSecondary"> ZKWRAP </h3>

          <ul className='flex bg-textPrimary py-[15px] px-[25px] items-center gap-x-[40px] rounded-[50px]'>
            { navlinks.map(link => (
              <Link to={`/main/${link.url}`} key={link.title}>
                <a className="font-poppins font-semibold" href={link.url}>{link.title}</a>
              </Link>
            )) }
          </ul>

          <div className='flex items-center gap-x-[20px]'>
              <button className='bg-secondary py-[10px] px-[15px] rounded-[10px] text-textPrimary font-semibold '> Connect Wallet </button>
            <Theme />
          </div>
       </nav>
    </div>
  )
}

export default Header