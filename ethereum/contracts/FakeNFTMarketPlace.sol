//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

contract FakeNFTMarketPlace {
    mapping(uint256 => address) tokens;
    uint256 nftPrice = 0.1 ether;

    function purchase(uint256 _tokenId) public payable {
        require(msg.value == nftPrice, "NFT costs exactly 0.01 ether");
        tokens[_tokenId] = msg.sender;
    }

    function getPrice() external view returns (uint256) {
        return nftPrice;
    }

    function available(uint256 _tokenId) external view returns (bool) {
        if (tokens[_tokenId] == address(0)) {
            return true;
        }

        return false;
    }
}
