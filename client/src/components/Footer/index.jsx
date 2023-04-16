import { Link } from "react-router-dom"
import { socialMedias } from "../../constants"

const Footer = () => {
  return (
    <div className="h-[80px] w-full flex mt-[50px] justify-center">

       <div className="flex items-center h-full gap-[20px] ">
          { socialMedias.map(social => (
             <Link to={social.link}>
                <social.Icon className="text-textSecondary font-semibold font-poppins md:text-[28px] text-[24px] " />
             </Link>
          )) }
       </div>

    </div>
  )
}

export default Footer