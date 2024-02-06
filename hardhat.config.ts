import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy-ethers";
import "hardhat-deploy";
import "hardhat-tracer";
import "@nomicfoundation/hardhat-viem";
import "hardhat-gas-reporter"
import "hardhat-contract-sizer";
import "@nomicfoundation/hardhat-verify";
import "hardhat-abi-exporter";

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
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL || '',
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
    },
    baseSepolia: {
      url: process.env.BASE_SEPOLIA_RPC_URL || '',
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
      verify: {
        etherscan: {
          apiUrl: "https://api-sepolia.basescan.org",
          apiKey: process.env.ETHERSCAN_API_KEY    
        }
      }
    },
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
    alice: {
      default: 2,
    },
    bob: {
      default: 3,
    },
    owner: {
      default: 4,
      sepolia: '0x0DE88BB60657B7Cabf35C160C52a4903b8271b54',
      baseSepolia: '0x0DE88BB60657B7Cabf35C160C52a4903b8271b54',
    },
  },
  abiExporter: {
    path: './abi',
    clear: true,
    flat: true,
    only: [
      ':Account$',
      ':AccountFactory$',
      ':AccountBeaconProxy$',
    ],
    spacing: 2
  }
};

export default config;
