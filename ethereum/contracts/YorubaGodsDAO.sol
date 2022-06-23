// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketPlace {
    function getPrice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);

    function purchase(uint256 _tokenId) external payable;
}

interface IYorubaGods {
    function balanceOf(address owner) external returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);
}

contract YorubaGodsDAO is Ownable {
    struct Proposal {
        uint256 nftTokenId;
        uint256 deadline;
        uint256 yayVotes;
        uint256 nayVotes;
        bool executed;
        mapping(uint256 => bool) votes;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public numProposals;

    IFakeNFTMarketPlace nftMarketPlace;
    IYorubaGods yorubaGods;

    enum Vote {
        YAY,
        NAY
    }

    // @dev the constructor is made payable so the DAO can be initialised
    // with a treasury.
    constructor(address _nftMarketPlace, address _yorubaGods) payable {
        nftMarketPlace = IFakeNFTMarketPlace(_nftMarketPlace);
        yorubaGods = IYorubaGods(_yorubaGods);
    }

    modifier nftHolderOnly() {
        require(yorubaGods.balanceOf(msg.sender) > 0, "Not a DAO member");
        _;
    }

    modifier activeProposalsOnly(uint256 proposalIndex) {
        require(
            proposals[proposalIndex].deadline > block.timestamp,
            "Deadline exceeded."
        );
        _;
    }

    function createProposal(uint256 _nftTokenId)
        external
        nftHolderOnly
        returns (uint256)
    {
        require(
            nftMarketPlace.available(_nftTokenId),
            "This NFT is not for sale."
        );

        Proposal storage proposal = proposals[_nftTokenId];
        proposal.nftTokenId = _nftTokenId;
        proposal.deadline = block.timestamp + 5 minutes;

        numProposals++;

        return numProposals - 1;
        // returns the index for the newly created proposal
    }
}
