import { Provider, Web3Provider } from "zksync-web3";
import * as ethers from "ethers";
import dotenv from "dotenv";
dotenv.config();
import * as ContractArtifact from "./contract.json";

const PRIVATE_KEY = process.env.PRIVATE || "";

if (!PRIVATE_KEY)
  throw "⛔️ Private key not detected! Add it to the .env file!";

const CONTRACT_ADDRESS = "0xE5c005FEfb767aA1e842aE8c55679E502f5887fD";

export const provider = new Provider("https://zksync-era-testnet.rpc.thirdweb.com");
export const signerDev = new ethers.Wallet(PRIVATE_KEY, provider);

const signer = (new Web3Provider(window.ethereum)).getSigner();
export const contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    ContractArtifact.abi,
    signer
  );

export const ZKContext = React.createContext();

