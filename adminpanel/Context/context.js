import { Provider, Web3Provider } from "zksync-web3";
import * as ContractArtifact from "./contract.json";
import {connectWallet} from "./helper.js";
import { useEffect, useState } from "react";
import React from "react";
import { ethers } from "ethers";
import Web3Modal from "web3modal";

const PRIVATE_KEY = process.env.PRIVATE || "";

if (!PRIVATE_KEY)
  throw "⛔️ Private key not detected! Add it to the .env file!";

const CONTRACT_ADDRESS = "0xE5c005FEfb767aA1e842aE8c55679E502f5887fD";

const provider = new Provider("https://zksync-era-testnet.rpc.thirdweb.com");
const signerDev = new ethers.Wallet(PRIVATE_KEY, provider);

const signer = new Web3Provider(window.ethereum).getSigner();

export const ZKContext = React.createContext();

export const ZKContractProvider =({children})=>{
  const [user , setUser] = useState("");
  const [contractObj , setOBJ] = useState();

  const fetch = async()=>{
    try {
      const contract = new ethers.Contract(
        CONTRACT_ADDRESS,
        ContractArtifact.abi,
        signer
      );
      setOBJ(contract);
      console.log(contract);
      const connectWall = await connectWallet();
      setUser(connectWall);
    } catch (error) {
      alert("error check console for details");
      console.log(error);
    }
  }

  useEffect(()=>{
    fetch();
  },[]);

  return(
    <ZKContext.provider value={{user , contractObj  ,signerDev , provider}}>
      {children}
    </ZKContext.provider>
  )
}


/* ERROR SHOWING THIS 
Context\context.js (18:32) @ window

  16 | const signerDev = new ethers.Wallet(PRIVATE_KEY, provider);
  17 | 
> 18 | const signer = new Web3Provider(window.ethereum).getSigner();
     |                                ^
  19 | 
  20 | export const ZKContext = React.createContext();
  21 | 

*/

