// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NFT.sol";

contract NFTTest is Test{
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    NFT nft;
    
    function setUp() external {
        nft = new NFT();
    }

    function testInfo() external {
        assertEq(nft.name(), "NFT");
        assertEq(nft.symbol(), "NFT");
    }

    function testMint(uint256 tokenId) external {
        //arrange
        uint256 totalSupply = nft.totalSupply();
        vm.assume(tokenId <= totalSupply);
        uint256 userPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(userPrivateKey);
        console.log(user);
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), user, tokenId);
        vm.broadcast(userPrivateKey);

        //act
        nft.mint(user, tokenId);

        //assert
        assertEq(nft.ownerOf(tokenId), user);
        assertEq(nft.balanceOf(user), 1);
    }

    function testFail_WhenTokenIdGreaterThanTotalSupply(uint256 tokenId) external{
        //arrange
        uint256 totalSupply = nft.totalSupply();
        vm.assume(tokenId > totalSupply);

        uint256 userPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(userPrivateKey);
        vm.broadcast(userPrivateKey);

        //act
        nft.mint(user, tokenId);
    }

    function testRevert_WhenTokenIdGreaterThanTotalSupply(uint256 tokenId) external{
        //arrange
        uint256 totalSupply = nft.totalSupply();
        vm.assume(tokenId > totalSupply);

        uint256 userPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(userPrivateKey);
        vm.broadcast(userPrivateKey);

        //assert
        vm.expectRevert("NFT: tokenId is out of range");

        //act
        nft.mint(user, tokenId);
    }
}