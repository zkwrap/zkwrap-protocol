import { Banner, Search } from "../../components"

import { poolsData } from "../../constants"

const Pools = () => {
  return (
    <div className='w-full'>
       <div className='w-[90%] mx-auto'>

        <Banner title="Pools" desc='Add liquidity and earn weekly rewards' Icon="#" />

        <Search /> 
        
        <div className="mt-[50px] items-center dark:bg-third bg-textPrimary h-[400px] dark:text-textPrimary text-textSecondary w-full"> 

            <div className={`flex ${poolsData.tokenPairs.length > 3 && poolsData.aprPercentages.length > 3 && poolsData.totalPools.length > 3 ? "overflow-y-scroll" : "overflow-y-hidden" } flex-row w-[90%] h-full p-[30px] mx-auto items-start justify-between gap-[50px]`}>

              <div className="flex flex-col items-center gap-y-[15px]">
                 <h3> Pair </h3>
                { poolsData.tokenPairs.map(pair => (
                  <div key={pair.id}>
                      <div>
                        {/* icons */}
                      </div>
                      <div>
                        <h3> {pair.title} </h3>
                        <p> {pair.Banner} </p>
                      </div>
                  </div>
                )) }
              </div>

              <div className="flex flex-col items-center gap-y-[15px]">
                <h3> APR </h3>
                { poolsData.aprPercentages.map(percentage => (
                    <h3 key={percentage.id}> {percentage.percentage} </h3>
                )) }
              </div>

              <div className="flex flex-col items-center gap-y-[15px]">
                 <h3> My Pool Amount </h3>
                { poolsData.totalPools.map(totalPool => (
                    <div>
                       <h3> {totalPool.amountA} {totalPool.tokenA} </h3>
                       <h3> {totalPool.amountB} {totalPool.tokenB} </h3>
                    </div>
                )) }
              </div>

              <div className="flex flex-col items-center gap-y-[15px]">
                <h3> Total Pool Amount </h3>
                { poolsData.totalPools.map(totalPool => (
                    <div>
                       <h3> {totalPool.amountA} {totalPool.tokenA} </h3>
                       <h3> {totalPool.amountB} {totalPool.tokenB} </h3>
                    </div>
                )) }
              </div>

            </div>

         </div>

       </div>
    </div>
  )
}

export default Pools