// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// Storage is stored in the proxy not in the implementation.
// And proxy contract borrows the logic of implementation contract and delegatecall to that implementation contract.

//But the thing is proxy contract do not use constructor so that's why. Since proxied contracts do not make use of a constructor, it's common to move constructor
// logic to anexternal initializer function, usually called `initialize
//so for that we have to  first deploy proxy and then implementation and call some Intializer funciton. it is going to be our constructor except of
// it is going to be called on proxy.
contract BoxV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal value;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers(); //this funciton is going to disable the initializer function. so that we can call it on proxy.
    }

    function initialize() public initializer { // this function will let us call the initializer function on proxy. and let proxy to have the storage
        __Ownable_init(msg.sender); // if we wanna have owner for BOX v1 we can't have it like owner = msg.sender. we have to use openzeppelin's ownable contract.
        __UUPSUpgradeable_init();
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function version() public pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}