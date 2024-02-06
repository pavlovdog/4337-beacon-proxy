// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  IBeacon
} from "./interfaces/IBeacon.sol";

import {
  ERC1967UtilsExtended
} from './libraries/ERC1967UtilsExtended.sol';

import {
  Proxy
} from "@openzeppelin/contracts/proxy/Proxy.sol";

import {
  Initializable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {
  BaseAccount,
  UserOperation,
  IEntryPoint
} from "@eth-infinitism/account-abstraction/contracts/core/BaseAccount.sol";

import {
  IBeaconProxy
} from "./interfaces/IBeaconProxy.sol";


abstract contract BeaconProxy is 
  Proxy,
  BaseAccount,
  IBeaconProxy,
  Initializable
{
  address private immutable _beacon;
  address private immutable _entryPoint;

  constructor(
    address __beacon,
    address __entryPoint
  ) payable {
    _beacon = __beacon;
    _entryPoint = __entryPoint;
  }

  function initialize(
    address __implementation,
    bytes memory data
  ) external override initializer {
    ERC1967UtilsExtended.upgradeBeaconToAndCallInitializer(
      _beacon,
      __implementation,
      data
    );
  }

  function entryPoint() public view override returns (IEntryPoint) {
    return IEntryPoint(_entryPoint);
  }

  function _implementation() internal view virtual override returns (address) {
    return IBeacon(_getBeacon()).implementation();
  }

  function _getBeacon() internal view virtual returns (address) {
    return _beacon;
  }

  receive() external payable {}
}