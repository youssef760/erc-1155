const { ethers } = require("hardhat");

async function main() {
  // Get the contract factory
  const ERC1155 = await ethers.getContractFactory("ERC1155");

  // Deploy the contract
  const erc1155 = await ERC1155.deploy();
  await erc1155.deployed();

  console.log("ERC1155 Contract deployed to:", erc1155.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });