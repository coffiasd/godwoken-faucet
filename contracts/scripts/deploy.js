const hre = require("hardhat");

const main = async () => {
  // The first return is the deployer, the second is a random account
  const total = hre.ethers.utils.parseEther("10000");
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const godWokenContractFactory = await hre.ethers.getContractFactory('NervosBridge');
  const godwokenContract = await godWokenContractFactory.deploy(total);
  await godwokenContract.deployed();
  console.log("Contract deployed to:", godwokenContract.address);
  console.log("Contract deployed by:", owner.address);
  // console.log("randomPerson:", randomPerson.address);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();