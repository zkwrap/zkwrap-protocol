
const Banner = ({title, desc, Icon}) => {

  return (
    <div className='flex md:flex-row flex-col dark:bg-third bg-textPrimary px-[30px] items-center h-[200px] rounded-[10px] justify-between w-full'>
      <div>
            <h3 className='md:text-[2.5rem] dark:text-textPrimary text-textSecondary text-[1.5rem] font-poppins font-bold'> {title} </h3>
            <p className='md:text-[18px] dark:text-textPrimary text-textSecondary text-[16px] font-poppins font-medium'>{desc}</p>
     </div>

        <h3> logo </h3>
    </div>
  )
}

export default Banner