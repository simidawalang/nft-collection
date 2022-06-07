const { ethers } = require("hardhat");

const deploy = async () => {
  const Whitelist = await ethers.getContractFactory("Whitelist");
  const whitelist = await Whitelist.deploy(10);
  // Max of 10 addresses can be whitelisted

  await whitelist.deployed();

  console.log("Whitelist deployed to:", whitelist.address); //
};

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
