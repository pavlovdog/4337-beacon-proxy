// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  IAccount
} from "./../interfaces/sample/IAccount.sol";

import {
  Initializable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {
  ReentrancyGuardUpgradeable
} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

import {
  OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract Account is 
  Initializable,
  ReentrancyGuardUpgradeable,
  OwnableUpgradeable,
  IAccount
{
  uint8 private immutable accountVersion;
  address public immutable entryPoint; 

  modifier onlyOwnerOrEntryPoint() {
    if (msg.sender != entryPoint && msg.sender != owner()) {
      revert InvalidSender();
    }

    _;
  }

  constructor(
    uint8 _accountVersion,
    address _entryPoint
  ) {
    accountVersion = _accountVersion;
    entryPoint = _entryPoint;

    _disableInitializers();    
  }

  function version() external override view returns (uint8) {
    return accountVersion;
  }

  function _call(address target, uint256 value, bytes memory data) internal {
    (bool success, bytes memory result) = target.call{value: value}(data);
    if (!success) {
      assembly {
        revert(add(result, 32), mload(result))
      }
    }
  }

  /**
    * Execute a transaction (called directly from owner, or by entryPoint)
    * @param dest destination address to call
    * @param value the value to pass in this call
    * @param func the calldata to pass in this call
    */
  function execute(
    address dest,
    uint256 value,
    bytes calldata func
  ) external onlyOwnerOrEntryPoint {
    // _requireFromEntryPointOrOwner();
    _call(dest, value, func);
  }

  /**
    * Execute a sequence of transactions
    * @dev to reduce gas consumption for trivial case (no value), use a zero-length array to mean zero value
    * @param dest an array of destination addresses
    * @param value an array of values to pass to each call. can be zero-length for no-value calls
    * @param func an array of calldata to pass to each call
    */
  function executeBatch(
    address[] calldata dest,
    uint256[] calldata value,
    bytes[] calldata func
  ) external onlyOwnerOrEntryPoint {
      require(dest.length == func.length && (value.length == 0 || value.length == func.length), "wrong array lengths");

      if (value.length == 0) {
        for (uint256 i = 0; i < dest.length; i++) {
          _call(dest[i], 0, func[i]);
        }
      } else {
        for (uint256 i = 0; i < dest.length; i++) {
          _call(dest[i], value[i], func[i]);
        }
      }
  }
}