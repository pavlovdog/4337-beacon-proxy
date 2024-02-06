// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  Ownable
} from "@openzeppelin/contracts/access/Ownable.sol";

import {
  IBeacon
} from "./interfaces/IBeacon.sol";

import {
  IVersion
} from "./interfaces/utils/IVersion.sol";


contract Beacon is Ownable, IBeacon {
  address private _implementation;

  constructor(
    address __implementation,
    address __owner
  ) Ownable(__owner) {
    _setImplementation(__implementation);
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
}