import { ethers } from "ethers";
import { readFileSync } from "fs";
import { resolve } from "path";
import * as dotenv from "dotenv";
dotenv.config();

async function main() {
  console.log("Deploying contract to Sepolia...");

  const artifactPath = resolve("artifacts/contracts/Certificate.sol/Certificate.json");
  const artifact = JSON.parse(readFileSync(artifactPath, "utf8"));

  const provider = new ethers.JsonRpcProvider(process.env.SEPOLIA_RPC_URL!);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

  console.log("Deploying from:", wallet.address);

  const balance = await provider.getBalance(wallet.address);
  console.log("Balance:", ethers.formatEther(balance), "ETH");

  const factory = new ethers.ContractFactory(artifact.abi, artifact.bytecode, wallet);
  const contract = await factory.deploy();
  await contract.waitForDeployment();

  const address = await contract.getAddress();
  console.log("✅ Contract deployed to Sepolia at:", address);
  console.log("📋 Copy this address and paste in Contract.js");
}

main().catch(console.error);