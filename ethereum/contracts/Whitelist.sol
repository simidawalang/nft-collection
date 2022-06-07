//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Whitelist {
    uint8 public maxWhitelistedAddresses;
    uint8 public numAddressesWhitelisted;

    mapping(address => bool) public whitelistedAddresses;

    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    function addAddressToWhitelist() public {
        require(
            numAddressesWhitelisted < maxWhitelistedAddresses,
            "Maximum number of whitelisted addresses reached."
        );
        require(
            !whitelistedAddresses[msg.sender],
            "This address has already been whitelisted."
        );
        whitelistedAddresses[msg.sender] = true;

        numAddressesWhitelisted ++;
    }
}
