// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import { IAccountFactory } from "./../interfaces/sample/IAccountFactory.sol";
import { IAccount } from "./../interfaces/sample/IAccount.sol";
import { IAccountBeaconProxy } from "./../interfaces/sample/IAccountBeaconProxy.sol";
import { AccountBeaconProxy } from "./AccountBeaconProxy.sol";

import { IBeacon } from "./../interfaces/IBeacon.sol";
import { IVersion } from "./../interfaces/utils/IVersion.sol";

import { IEntryPoint } from "@eth-infinitism/account-abstraction/contracts/interfaces/IEntryPoint.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";


contract AccountFactory is IAccountFactory, IBeacon, OwnableUpgradeable {
  IEntryPoint internal immutable _entryPoint;
  AccountBeaconProxy internal _beaconProxy;
  address internal immutable _payMaster;

  address internal _implementation;

  constructor(
    address __entrypoint
  ) {
    _entryPoint = IEntryPoint(__entrypoint);

    _disableInitializers();
  }

  function initialize(
    address __implementation,
    address __owner
  ) external initializer {
    _setImplementation(__implementation);

    _beaconProxy = new AccountBeaconProxy(
      address(this),
      address(_entryPoint)
    );

    __Ownable_init(__owner);
  }

  function _setImplementation(
    address __implementation
  ) internal {
    if (__implementation.code.length == 0) {
      revert EmptyImplementation();
    }

    _implementation = __implementation;

    emit ImplementationUpdated(__implementation);
  }

  function setImplementation(
    address __implementation
  ) external override onlyOwner {
    uint currentVersion = IVersion(_implementation).version();
    uint newVersion = IVersion(__implementation).version();

    if (newVersion <= currentVersion) {
      revert InvalidVersion(currentVersion, newVersion);
    }

    _setImplementation(__implementation);
  }

  function implementation() external override view returns (address) {
    return _implementation;
  }

  function entryPoint() external override view returns (address) {
    return address(_entryPoint);
  }

  function beaconProxy() external override view returns (address) {
    return address(_beaconProxy);
  }

  function payMaster() external override view returns (address) {
    return _payMaster;
  }

  function deployAccount(
    address accountOwner
  ) external override returns (address account) {
    account = deriveAccount(accountOwner);

    if (account.code.length != 0) return account;

    account = Clones.cloneDeterministic(
      address(_beaconProxy),
      getAccountSalt(accountOwner)
    );

    bytes memory initData = abi.encodeWithSelector(
      IAccount.initialize.selector,
      accountOwner
    );

    IAccountBeaconProxy(account).initialize(
      _implementation,
      initData
    );

    emit AccountDeployed(accountOwner, account);
  }

  function getBeaconProxyCreationCode() public pure returns(bytes memory) {
    return type(AccountBeaconProxy).creationCode;
  }

  function getAccountSalt(address accountOwner) public pure returns(bytes32) {
    return keccak256(abi.encodePacked(accountOwner));
  }

  function getBeaconProxyInitHash() public pure returns(bytes32) {
    return keccak256(abi.encodePacked(getBeaconProxyCreationCode()));
  }

  function deriveAccount(
    address accountOwner
  ) public override view returns (address account) {
    return Clones.predictDeterministicAddress(
      address(_beaconProxy),
      getAccountSalt(accountOwner)
    );
  }

  /**
    * Add stake for this paymaster.
    * This method can also carry eth value to add to the current stake.
    * @param unstakeDelaySec - The unstake delay for this paymaster. Can only be increased.
    */
  function addStake(uint32 unstakeDelaySec) external payable onlyOwner {
    _entryPoint.addStake{value: msg.value}(unstakeDelaySec);
  }

  /**
    * Unlock the stake, in order to withdraw it.
    * The paymaster can't serve requests once unlocked, until it calls addStake again
    */
  function unlockStake() external onlyOwner {
    _entryPoint.unlockStake();
  }

  /**
    * Withdraw the entire paymaster's stake.
    * stake must be unlocked first (and then wait for the unstakeDelay to be over)
    * @param withdrawAddress - The address to send withdrawn value.
    */
  function withdrawStake(address payable withdrawAddress) external onlyOwner {
    _entryPoint.withdrawStake(withdrawAddress);
  }
}