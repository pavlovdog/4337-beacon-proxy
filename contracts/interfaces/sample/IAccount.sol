// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  IVersion
} from "./../utils/IVersion.sol";

interface IAccount is IVersion {
  error InvalidSender();

  function initialize(
    address accountOwner
  ) external;
}