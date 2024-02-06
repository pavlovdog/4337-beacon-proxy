// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


interface IBeaconProxy {
  function initialize(
    address _initializer,
    bytes memory data
  ) external;
}