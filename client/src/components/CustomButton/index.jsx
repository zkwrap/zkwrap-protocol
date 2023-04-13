import React from 'react'

const CustomButton = ({title, styles}) => {
  return (
    <button className={`border-none w-[150px] rounded-[10px] outline-none bg-secondary text-textPrimary p-[10px]`}>
        {title}
    </button>
  )
}

export default CustomButton