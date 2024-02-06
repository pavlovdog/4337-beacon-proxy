import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';


const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {deployments, getNamedAccounts} = hre;

  const {
    deployer,
    entrypoint
  } = await getNamedAccounts();

  await deployments.deploy('Account', {
    from: deployer,
    log: true,
    args: [
      0, // account version
      entrypoint,
    ]
  });
}

export default func;
func.tags = ['Deploy_Account_Implementation'];