// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract YorubaGods is ERC721Enumerable, Ownable {
    string _baseTokenURI;
    uint public _price = 0.01 ether;
    uint public tokenIds;
    uint public maxTokenIds = 20;
    uint public presaleEnded;
    bool public presaleStarted;
    bool public _paused;

    IWhitelist whitelist;

    modifier onlyWhenNotPaused {
        require(!_paused, "This contract has been temporarily paused.");
        _;
    }

    constructor(string memory baseURI, address whitelistContract) ERC721("Yoruba Gods", "YBG"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "The presale hasn't started yet.");
        require(whitelist.whitelistedAddresses(msg.sender), "This address was not whitelisted.");
        require(tokenIds < maxTokenIds, "Maximum supply reached");
        require(msg.value >= _price, "Send exactly 0.01 ether");

        tokenIds++;

        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp > presaleEnded, "The presale hasn't ended yet");
        require(tokenIds < maxTokenIds, "Max supply reached.");
        require(msg.value >= _price, "Ether sent is not correct");
          
        tokenIds++;
    }
   function _baseURI() internal view virtual override returns (string memory) {
          return _baseTokenURI;
      }
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint amount = address(this).balance;
        (bool sent,) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether.");
    }

    receive() external payable {}

    fallback() external payable {}
}