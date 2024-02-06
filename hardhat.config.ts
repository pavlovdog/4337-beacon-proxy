import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy-ethers";
import "hardhat-deploy";
import "hardhat-tracer";
import "@nomicfoundation/hardhat-viem";
import "hardhat-gas-reporter"
import "hardhat-contract-sizer";
import "@nomicfoundation/hardhat-verify";
// import "hardhat-abi-exporter";
// import "hardhat-storage-layout";

import "dotenv/config";


const config: HardhatUserConfig = {
  solidity: "0.8.21",
  mocha: {
    timeout: 100000000
  },
  tracer: {
    gasCost: true,
  },
  networks: {
    hardhat: {},
  },
  verify: {
    etherscan: {
      apiKey: process.env.ETHERSCAN_API_KEY
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    entrypoint: {
      default: '0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789'
    },
    paymaster: {
      default: '0xE93ECa6595fe94091DC1af46aaC2A8b5D7990770'
    },
    bank: {
      // Binance
      // https://optimistic.etherscan.io/address/0xacD03D601e5bB1B275Bb94076fF46ED9D753435A
      default: '0xacD03D601e5bB1B275Bb94076fF46ED9D753435A',
    },
    usdc: {
      // https://optimistic.etherscan.io/address/0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85
      default: '0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85',
      // https://docs.stackup.sh/docs/supported-erc-20-tokens#ethereum-sepolia
      sepolia: '0x3870419Ba2BBf0127060bCB37f69A1b1C090992B',
    },
    eth: {
      default: '0x1111111111111111111111111111111111111111'
    },
    alice: {
      default: 2,
    },
    bob: {
      default: 3,
    },
    owner: {
      default: 4,
    }
  },
  // gasReporter: {
  //   enabled: true,
  // }
};

export default config;
