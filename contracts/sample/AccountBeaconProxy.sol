// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  BeaconProxy
} from "./../BeaconProxy.sol";

import {
  MessageHashUtils
} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

import {
  ECDSA
} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {
  UserOperation
} from "@eth-infinitism/account-abstraction/contracts/core/BaseAccount.sol";


contract AccountBeaconProxy is BeaconProxy {
  using MessageHashUtils for bytes32;
  using ECDSA for bytes32;

  constructor(
    address __beacon,
    address __entryPoint
  ) payable BeaconProxy(__beacon, __entryPoint) {}

  function _validateSignature(
    UserOperation calldata userOp,
    bytes32 userOpHash
  ) internal override virtual returns (uint256 validationData) {
    bytes32 hash = userOpHash.toEthSignedMessageHash();

    if (address(0) != hash.recover(userOp.signature)) return SIG_VALIDATION_FAILED;

    return 0;
  }
}