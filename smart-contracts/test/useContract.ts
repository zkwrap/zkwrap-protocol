import { Provider } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";

// load env file
import dotenv from "dotenv";
dotenv.config();

// load contract artifact. Make sure to compile first!
import * as ContractArtifact from "../artifacts-zk/contracts/Lock.sol/Lock.json";

const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || "";

if (!PRIVATE_KEY)
  throw "⛔️ Private key not detected! Add it to the .env file!";

// Address of the contract on zksync 
const CONTRACT_ADDRESS = "Contract Address";

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
  console.log(`The current owner is ${await contract.getFunction()}`);

  // call function
  const newOwner = "Sample Data";
  const tx = await contract.ExampleFunctiom(newOwner);

  console.log(`Transaction to change the message is ${tx.hash}`);
  await tx.wait();

  console.log(`The new owner is now ${await contract.getFunction()}`);
}
