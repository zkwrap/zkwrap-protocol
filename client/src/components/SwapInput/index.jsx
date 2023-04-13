import React from 'react'

const SwapInput = () => {
  return (
    <div className='flex w-[90%] h-[140px] dark:bg-third mx-auto p-[20px] rounded-[10px] bg-gray-300 flex-col gap-y-[10px]'>

        <div className='w-full flex flex-row justify-between'>
           <div className='flex gap-[20px]'>
               <span className='px-[10px] py-[3px] font-poppins font-normal text-[12px] cursor-pointer text-textPrimary rounded-[10px] dark:bg-gray-500 bg-third '>Half</span>
               <span className='px-[10px] py-[3px] font-poppins font-normal text-[12px] cursor-pointer text-textPrimary rounded-[10px] dark:bg-gray-500 bg-third '>Max</span>
           </div>

           <span className='font-poppins flex gap-x-[5px] font-normal text-[16px] dark:text-textPrimary text-textSecondary'>
             {/* icon */}
              0.00
           </span>
        </div>

        <div className='flex gap-x-[4px]'>
            {/* tokenIcon */}
            <div>
                <input 
                    type='text' placeholder='0.00' 
                    className='border-none outline-none bg-transparent rounded-[10px] p-[4px] md:text-[28px] text-[20px] font-poppins text-gray-300 ' /> 
                <h3 className='font-poppins dark:text-textPrimary text-textSecondary '> ETH </h3>
            </div>
        </div>
    </div>
  )
}

export default SwapInput