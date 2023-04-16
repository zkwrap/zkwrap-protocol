import React from 'react'

const CustomButton = ({title, styles, clickHandler}) => {
  return (
    <button onClick={clickHandler} className={`border-none w-[150px] ${styles} rounded-[10px] outline-none bg-secondary text-textPrimary p-[10px]`}>
        {title}
    </button>
  )
}

export default CustomButton