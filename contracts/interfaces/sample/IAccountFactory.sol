// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


interface IAccountFactory {
  event AccountDeployed(address accountOwner, address account);

  function deriveAccount(
    address accountOwner
  ) external view returns (address account);

  function deployAccount(
    address accountOwner
  ) external returns (address account);

  function payMaster() external view returns (address);
  function beaconProxy() external view returns (address);
  function entryPoint() external view returns (address);
}