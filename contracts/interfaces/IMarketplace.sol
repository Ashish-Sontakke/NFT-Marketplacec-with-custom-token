// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Stable coins.
// USDC USDT DAI

interface IMarketplace {
    event Listed(uint256 tokenId, uint256 price);
    event Bought(uint256 tokenId, address owners);

    function listForSale(uint256 tokenId, uint256 price) external;

    function buy(uint256 tokenId) external payable;

    function changePrice(uint256 tokenId, uint256 newPrice) external;
}
