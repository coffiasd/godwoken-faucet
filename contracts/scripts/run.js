const hre = require("hardhat");

const main = async () => {
    // The first return is the deployer, the second is a random account
    const total = hre.ethers.utils.parseEther("10000");
    const [owner, accountOne, accountTwo, accountThree] = await hre.ethers.getSigners();
    const godWokenContractFactory = await hre.ethers.getContractFactory('NervosBridge');
    const godwokenContract = await godWokenContractFactory.deploy(total);
    await godwokenContract.deployed();
    console.log("Contract deployed to:", godwokenContract.address);
    console.log("Contract deployed by:", owner.address);

    await godwokenContract.transfer(accountOne.address, 100)
    await godwokenContract.transfer(godwokenContract.address, 1000)
    await godwokenContract.connect(accountOne).transfer(accountTwo.address, 20)
    // await godwokenContract.connect(accountThree).withDrawSomeToken()
    console.log("owner balance:", owner.address, await godwokenContract.balanceOf(owner.address));
    console.log("contract balance", await godwokenContract.balanceOfContracts(), await godwokenContract.balanceOf(godwokenContract.address));
    console.log("accountOne balance:", accountOne.address, await godwokenContract.balanceOf(accountOne.address));
    console.log("accountTwo balance:", accountTwo.address, await godwokenContract.balanceOf(accountTwo.address));
    // console.log("accountThree balance:", await godwokenContract.balanceOf(accountThree.address));
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