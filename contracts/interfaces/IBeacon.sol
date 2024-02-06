// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  IBeacon as IBeacon_
} from "@openzeppelin/contracts/proxy/beacon/IBeacon.sol";


interface IBeacon is IBeacon_ {
  error EmptyImplementation();
  error InvalidVersion(uint currentVersion, uint newVersion);

  event ImplementationUpdated(address implementation);

  function setImplementation(address __implementation) external;
}