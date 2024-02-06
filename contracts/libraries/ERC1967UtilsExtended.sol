// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;


import {
  Address
} from "@openzeppelin/contracts/utils/Address.sol";

import {
  StorageSlot
} from "@openzeppelin/contracts/utils/StorageSlot.sol";

import {
  ERC1967Utils
} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";


library ERC1967UtilsExtended {
  function upgradeBeaconToAndCallInitializer(
    address newBeacon,
    address initializer,
    bytes memory data
  ) internal {
    _setBeacon(newBeacon);
    emit ERC1967Utils.BeaconUpgraded(newBeacon);

    if (data.length > 0) {
      Address.functionDelegateCall(initializer, data);
    } else {
      _checkNonPayable();
    }
  }

  bytes32 internal constant BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

  function _setBeacon(address newBeacon) private {
    // Potentially vioates ERC4337 standard
    // if (newBeacon.code.length == 0) {
    //   revert ERC1967Utils.ERC1967InvalidBeacon(newBeacon);
    // }

    StorageSlot.getAddressSlot(BEACON_SLOT).value = newBeacon;

    // Violation of ERC4337 standard
    // address beaconImplementation = IBeacon(newBeacon).implementation();
    // if (beaconImplementation.code.length == 0) {
    //   revert ERC1967Utils.ERC1967InvalidImplementation(beaconImplementation);
    // }
  }


  function _checkNonPayable() private {
    if (msg.value > 0) {
      revert ERC1967Utils.ERC1967NonPayable();
    }
  }
}