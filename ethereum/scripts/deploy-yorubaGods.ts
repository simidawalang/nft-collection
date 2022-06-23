const { METADATA_URL, WHITELIST_ADDRESS } = require("../constants");

const deployYorubaGods = async () => {
  const YorubaGods = await ethers.getContractFactory("YorubaGods");
  const yorubaGods = await YorubaGods.deploy(METADATA_URL, WHITELIST_ADDRESS);

  await yorubaGods.deployed();

  console.log("YorubaGods deployed to:", yorubaGods.address);
  //0x8D9Ba7aC621A676CaAb10d15188A5962E3cE8E7E
};

deployYorubaGods()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
