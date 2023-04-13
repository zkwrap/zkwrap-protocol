import { useState } from 'react'
import { infoItems } from "../../constants"
import {CgClose} from "react-icons/cg"

const Info = () => {
    const [showInfo, setShowInfo] = useState(true)

  return (
    <div className={`bg-secondary ${showInfo ? "flex flex-row" : "hidden" } pr-[30px] items-center h-[50px] w-full`}>

        <div className='w-[80%] info mx-auto flex md:overflow-hidden overflow-x-scroll flex-row items-center gap-x-[20px]'>
            { infoItems.map(item => (
                <div key={item.id} className='flex flex-row items-center gap-x-[10px]'>
                    <h3 className="md:text-[16px] whitespace-nowrap text-[12px] font-poppins font-semibold text-textPrimary"> {item.title}: </h3>
                    <p className={`${item.id === 3 ? "underline" : ""} text-[#1cda37]`}> {item.info} </p>
               </div>
            )) }
        </div>

        <div>
            <CgClose 
                className='text-textPrimary cursor-pointer text-poppins font-bold md:text-[1.7rem] text-[1.5rem] 
                ' 
                onClick={() => setShowInfo(false)}    
            />
        </div>
    </div>
  )
}

export default Info