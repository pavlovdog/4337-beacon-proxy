// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


interface IAccountBeaconProxy {
  function initialize(
    address _initializer,
    bytes memory data
  ) external;
}