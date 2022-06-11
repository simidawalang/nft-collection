const { METADATA_URL, WHITELIST_ADDRESS } = require("../constants");

const deployYorubaGods = async () => {
  const YorubaGods = await ethers.getContractFactory("YorubaGods");
  const yorubaGods = await YorubaGods.deploy(METADATA_URL, WHITELIST_ADDRESS);
  // Max of 10 addresses can be whitelisted

  await yorubaGods.deployed();

  console.log("YorubaGods deployed to:", yorubaGods.address); //
};

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
