import { Provider } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";

// load env file
import dotenv from "dotenv";
dotenv.config();

// load contract artifact. Make sure to compile first!
import * as ContractArtifact from "../artifacts-zk/contracts/CNft.sol/CNft.json";

const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || "";

if (!PRIVATE_KEY)
  throw "⛔️ Private key not detected! Add it to the .env file!";

// Address of the contract on zksync 
const CONTRACT_ADDRESS = "0x451d1aF630eD72C6506c969e471c3d81F5932F6B";

if (!CONTRACT_ADDRESS) throw "⛔️ Contract address not provided";

// An example to call from a smart contract
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`Running script to interact with contract ${CONTRACT_ADDRESS}`);

  // Initialize the provider.
  // @ts-ignore
  const provider = new Provider(hre.userConfig.networks?.zkSyncTestnet?.url);
  const signer = new ethers.Wallet(PRIVATE_KEY, provider);

  // Initialise contract instance
  const contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    ContractArtifact.abi,
    signer
  );

  // read function
  console.log(`The current balance is ${await contract.getFaucetBalance()}`);

  // call function
 // const newOwner = "Sample Data";
  //const tx = await contract.ClaimNFT();

  //console.log(`Transaction to change the message is ${tx.hash}`);
  //await tx.wait();

 // console.log(`The new owner is now ${await contract.getFunction()}`);
}
