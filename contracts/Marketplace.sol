// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./interfaces/IMarketplace.sol";

import "./interfaces/IERC721.sol";

import {IERC20} from "./interfaces/IERC20.sol";

contract Marketplace is IMarketplace {
    uint256 itemIds;
    IERC721 myNFTContract;
    IERC20 myToken;

    // IERC20 myToken;

    struct ListedItem {
        uint256 tokenId;
        uint256 price;
        address seller;
        bool sold;
    }
    // id of listedItem => ListedItem
    mapping(uint256 => ListedItem) items;

    constructor(address ntfContract, address tokenContract) {
        myNFTContract = IERC721(ntfContract);
        myToken = IERC20(tokenContract);
    }

    function listForSale(uint256 tokenId, uint256 price) external {
        require(myNFTContract.ownerOf(tokenId) == msg.sender, "NOT_OWNER");
        require(price > 0, "INVALID_PRICE");

        items[itemIds] = ListedItem(tokenId, price, msg.sender, false);
        itemIds++;

        myNFTContract.transferFrom(msg.sender, address(this), tokenId);

        emit Listed(tokenId, price, msg.sender);
    }

    function buy(uint256 itemId) external override {
        require(itemIds > itemId, "DOES_NOT_EXIST");
        // even if does not exits it will return item with values (0,0, address(0), false);
        ListedItem storage item = items[itemId];
        require(!item.sold, "ITEM_SOLD");
        require(item.seller != msg.sender, "OWNER_CANNOT_BUY");

        item.sold = true;
        // buyer should have balance;
        address buyer = msg.sender;
        require(myToken.balanceOf(buyer) >= item.price, "INSUFFIEICNT_BALANCE");
        require(myToken.allowance(buyer, address(this)) >= item.price);
        // buyer should approve us to transfer;
        myToken.transferFrom(buyer, item.seller, item.price);

        myNFTContract.transferFrom(address(this), msg.sender, item.tokenId);
        emit Bought(item.tokenId, item.price, msg.sender);
    }

    function updatePrice(uint256 itemId, uint256 newPrice) external {
        require(newPrice > 0, "INVALID_PRICE");
        require(itemIds > itemId, "DOES_NOT_EXIST");
        // even if does not exits it will return item with values (0,0, address(0), false);
        ListedItem storage item = items[itemId];
        require(!item.sold, "ITEM_SOLD");
        require(item.seller == msg.sender, "ONLY_SELLER_CAN_UPDATE");

        item.price = newPrice;
        emit PriceChanged(itemId, newPrice);
    }
}
