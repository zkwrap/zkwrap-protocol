import { SwapInput, CustomButton } from "../../components"

const Swap = () => {
  return (
    <div className="w-full md:min-h-[600px] min-h-[700px] ">

      <div className="w-[90%] mx-auto h-full flex lg:flex-row flex-col gap-[30px] justify-between">
         
        <div className="h-[450px] md:w-[450px]">
            <div className="flex h-[90%] w-[90%] flex-col gap-[15px]">
                <h3 className="md:text-[2rem] font-bold font-poppins dark:text-textPrimary text-textSecondary text-[1.5rem]"> Swap </h3>
                <p className="md:text-[16px] font-normal font-poppins dark:text-textPrimary text-textSecondary text-[14px]"> Take advantage of Zkwrap's minimal slippage, low swapping fees, and deep liquidity </p>
            </div>
            <span> Logo </span>
        </div>

        <div className="h-[450px] md:w-[450px] rounded-[10px] bg-textPrimary ">
            <div className="h-[90%] flex flex-col justify-center gap-[20px] ">
               <SwapInput />
               {/* icon */}
               <SwapInput />
               <div className="flex items-center gap-[20px] justify-center ">
                  <CustomButton title="Enable Token" />
                  <CustomButton title="Swap" />
               </div>
            </div>
        </div>

      </div>

    </div>
  )
}

export default Swap