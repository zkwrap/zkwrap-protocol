import { FiSearch } from "react-icons/fi"

const Search = () => {
  return (
    <div className="flex w-full h-[50px] items-center justify-between mt-[40px]">

            <div className="flex h-full dark:bg-third bg-textPrimary rounded-[5px] px-[10px] w-[65%] gap-[10px] items-center">
                <FiSearch className="text-textSecondary text-[14px] font-poppins font-medium" />
                <input 
                    type="text" 
                    className="w-[97%] h-full p-[10px] bg-transparent border-none outline-none " 
                    placeholder="Search" 
                    />
            </div>

            <div className="flex h-full px-[10px] items-center justify-between w-[200px] border-[1px]">
                <h3> My Deposits </h3>
                <span> toggle </span>
            </div>

    </div>
  )
}

export default Search