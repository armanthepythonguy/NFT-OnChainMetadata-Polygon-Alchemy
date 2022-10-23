const hre = require("hardhat");

async function main() {
    const nftContractFactory = await hre.ethers.getContractFactory("ChainBattles")
    const nftContract = await nftContractFactory.deploy()
    await nftContract.deployed()
    console.log(`Address of the contract is :- ${nftContract.address}`)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
