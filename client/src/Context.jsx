import { createContext, useEffect, useContext, useState } from "react";
import { useContract, useContractWrite, useAddress } from "@thirdweb-dev/react";

import { zkContract, zkAbi } from "./constants"
import abi from "./constants/abi.json"
import * as zksync from "zksync-web3";
import { ethers } from "ethers"

const ZkContext = createContext();


export const ZkContextProvider = ({children}) => {
    const [darkTheme, setDarkTheme] = useState(false)
    const address = useAddress()

      const initializeContract = async() => {
        const PRIVATE_KEY =  '332c845ecc77da391cd03c616456b1aeeb9c5edbd566cf19606ccf70ff6c45f1'
        const provider = new zksync.Web3Provider(window.ethereum)
        const ethereumProvider = ethers.getDefaultProvider("goerli");
        const wallet = new zksync.Wallet(PRIVATE_KEY, provider, ethereumProvider);
        wallet.connect(provider)

        const contract = new ethers.Contract(zkContract, zkAbi, wallet)

        return { provider, wallet, contract }

      }

        const connectWallet = async() => {
            const { wallet } = initializeContract()

              try {
                if(typeof window.ethereum != "undefined") {
                   await window.ethereum.request({method: "eth_requestAccounts"})
    
                  console.log("ethereum wallet detected")
              
                }
            } catch(err) {
                  console.log("ethereum wallet not detected")
              }
          }
        
      

        const changeTheme = (status) => {
            setDarkTheme(status)
        }

    return (
        <ZkContext.Provider value={{ 
            changeTheme,
            darkTheme,
            connectWallet,
            initializeContract,
            address
         }}>
            {children}
        </ZkContext.Provider>
    )
}


export const useZkContext = () => useContext(ZkContext)