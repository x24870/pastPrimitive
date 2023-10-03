// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    uint256 public totalSupply = 100;

    constructor() ERC721("NFT", "NFT") {}

    function mint(address to, uint256 tokenId) public {
        require(tokenId <= totalSupply, "NFT: tokenId is out of range");
        _mint(to, tokenId);
    }
}