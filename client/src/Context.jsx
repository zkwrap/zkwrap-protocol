import { createContext, useEffect, useContext, useState } from "react";
import { useContract, useContractWrite } from "@thirdweb-dev/react";
import { ethers } from "ethers"
import { zkContract } from "./constants"
import abi from "./constants/abi.json"
import { Contract, Web3Provider, Provider } from "zksync-web3";

const ZkContext = createContext();

export const ZkContextProvider = ({children, initializeContract}) => {
        const [darkTheme, setDarkTheme] = useState(false)
        
        const functions = {
            provider: '',
            contract: '' | "con",
            signer: '',

            initializeProviderAndSigner() {
                this.provider = new Provider('https://testnet.era.zksync.dev');
                // Note that we still need to get the Metamask signer
                this.signer = (new Web3Provider(window.ethereum)).getSigner();
                this.contract = new Contract(
                    zkContract,
                    abi,
                    this.signer
                );
            },

            async getContract() {
                console.log(this.contract)
            }
        }

        const changeTheme = (status) => {
            setDarkTheme(status)
        }

    return (
        <ZkContext.Provider value={{ 
            changeTheme,
            darkTheme,
            getContract: functions.getContract()
         }}>
            {children}
        </ZkContext.Provider>
    )
}


export const useZkContext = () => useContext(ZkContext)