// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IMarketplace {
    event Listed(uint256 tokenId, uint256 price, address seller);

    event Bought(uint256 tokenId, uint256 price, address buyer);

    event PriceChanged(uint256 itemId, uint256 newPrice);

    function listForSale(uint256 tokenId, uint256 price) external;

    function buy(uint256 itemId) external;

    function updatePrice(uint256 tokenId, uint256 newPrice) external;
}

contract THisContract {}
