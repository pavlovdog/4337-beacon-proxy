import {
  ethers,
  deployments,
  getNamedAccounts,
} from 'hardhat';

import { Account, AccountFactory } from "../typechain-types";
import { parseUnits } from 'ethers';
import { expect } from 'chai';

let factory: AccountFactory;
let aliceAccount: Account;

describe('Test sample account', async () => {
  it('Deploy contracts', async () => {
    await deployments.fixture();

    factory = await ethers.getContract('AccountFactory');
  });

  it('Deploy account for Alice', async () => {
    const alice = await ethers.getNamedSigner('alice');

    await factory.deployAccount(alice.address);

    const account = await factory.deriveAccount(alice.address);

    aliceAccount = await ethers.getContractAt('Account', account);
  });

  describe('Send transaction', async () => {
    it('Fund Alice account', async () => {
      const deployer = await ethers.getNamedSigner('deployer');

      await deployer.sendTransaction({
        to: aliceAccount.target,
        value: parseUnits('1', 'ether')
      });
    });
  
    it('Alice sends ETH to Bob', async () => {
      const {
        alice,
        bob
      } = await ethers.getNamedSigners();

      const tx = aliceAccount.connect(alice).execute(
        bob.address,
        parseUnits('0.5', 'ether'),
        '0x'
      );

      await expect(tx).to.changeEtherBalance(
        bob,
        parseUnits('0.5', 'ether')
      );
    });  
  });

  describe('Upgrade account', async () => {
    let newAccount: Account;

    it('Check current version', async () => {
      const version = await aliceAccount.version();

      expect(version).to.equal(0);
    });

    it('Deploy new account implementation', async () => {
      const {
        deployer,
        entrypoint
      } = await getNamedAccounts();

      const newAccountImplementation = await deployments.deploy('Account', {
        from: deployer,
        log: true,
        args: [
          1, // new account version
          entrypoint
        ]
      });

      newAccount = await ethers.getContractAt('Account', newAccountImplementation.address);
    });

    it('Upgrade implementation in beacon', async () => {
      const beaconAddress = await factory.beacon();
      const beacon = await ethers.getContractAt('Beacon', beaconAddress);

      const owner = await ethers.getNamedSigner('owner');

      await beacon.connect(owner).setImplementation(newAccount.target);
    });

    it('Check new version', async () => {
      const version = await aliceAccount.version();

      expect(version).to.equal(1);
    });
  });
});