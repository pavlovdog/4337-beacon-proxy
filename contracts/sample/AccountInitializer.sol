// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  IAccountInitializer
} from "./../interfaces/sample/IAccountInitializer.sol";

import {
  OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract AccountInitializer is IAccountInitializer, OwnableUpgradeable {
  function initialize(
    address accountOwner
  ) external override {
    __Ownable_init(accountOwner);
  }
}