// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


interface IAccountInitializer {
  function initialize(
    address accountOwner
  ) external;
}