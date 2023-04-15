import { ImSun } from "react-icons/im"
import { BsMoonStarsFill } from "react-icons/bs"

import { useZkContext } from '../../Context'

const Theme = () => {
     const { darkTheme, changeTheme } = useZkContext()

  return (
    <div className={`w-[70px] ${ darkTheme ? "bg-primary" : "bg-secondary" } flex items-center ${darkTheme ? "justify-start" : "justify-end" } transition-all duration-500 rounded-[50px] p-[10px]`}>
        <ImSun 
            onClick={() => changeTheme(false)} 
            className={`text-textPrimary ${darkTheme ? "block" : "hidden" } font-bold font-poppins md:text-[20px] cursor-pointer`} />
        <BsMoonStarsFill 
            onClick={() => changeTheme(true)}  
            className={`text-textPrimary ${!darkTheme ? "block" : "hidden" } font-bold font-poppins md:text-[20px] cursor-pointer`} />
    </div>
  )
}

export default Theme