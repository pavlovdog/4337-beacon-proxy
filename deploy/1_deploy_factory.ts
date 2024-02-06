import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';


const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {
    deployments,
    getNamedAccounts
  } = hre;

  const {
    deployer,
    entrypoint,
    paymaster,
    owner
  } = await getNamedAccounts();

  const account = await deployments.get('Account');

  await deployments.deploy('AccountFactory', {
    from: deployer,
    log: true,
    proxy: {
      proxyContract: 'OpenZeppelinTransparentProxy',
      execute: {
        methodName: 'initialize',
        args: [
          owner,
        ]
      }
    },
    args: [
      entrypoint,
      account.address,
      owner,
      paymaster
    ]
  });
}

export default func;
func.tags = ['Deploy_Account_Factory'];