require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    godwoken: {
      // This value will be replaced on runtime
      url: process.env.STAGING_NERVOS_GODWOKEN_URL,
      accounts: [process.env.TEST_ACCOUNT_PRIVATE_KEY],
    },
  },
};
