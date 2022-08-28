// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./interfaces/IERC721.sol";

contract NFT is IERC721 {
    event NFTCreated(address owner, uint256 id, string uri);

    event NFTTransfered(address from, address to, uint256 tokenId, bytes info);

    uint256 public tokenId;

    // 1. What will be the contract state.

    // tokenId => owner;
    // {
    //     1: "address_1",
    //     2: "address_2",
    //     3: "address_1"
    // }

    mapping(uint256 => address) public ownerOf;
    //
    mapping(address => uint256) public balanceOf;

    // owner => token => who is allowed to spend
    mapping(address => mapping(uint256 => address)) allowance;

    // owner => operator => boolean
    mapping(address => mapping(address => bool)) allAllowance;

    // Ashish => token_2 => setAllowance[Ashsish other address]
    // Ashish sells this NFT to Jhon
    // Jhon is owner but still Ashsish other is allowed to transfer

    mapping(uint256 => string) tokenURIs;

    function name() external pure returns (string memory _name) {
        _name = "MY NTF Contracts";
    }

    function symbol() external pure returns (string memory _symbol) {
        _symbol = "MNC";
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        return tokenURIs[_tokenId];
    }

    //ipfs://hash
    //tokenURI must be unique
    function mint(string memory _tokenURI) external returns (uint256) {
        require(bytes(_tokenURI).length > 5, "invalid_uri");

        ownerOf[tokenId] = msg.sender;
        balanceOf[msg.sender] += 1;
        tokenURIs[tokenId] = _tokenURI;

        tokenId++;
        emit NFTCreated(msg.sender, tokenId - 1, _tokenURI);
        return tokenId - 1;
    }

    function transfer(address to, uint256 _tokenId) external {
        require(_tokenId < tokenId, "DOES_NOT_EXIST");
        require(ownerOf[_tokenId] == msg.sender, "NOT_OWNER");

        ownerOf[_tokenId] = to;
        balanceOf[msg.sender] -= 1;
        balanceOf[to] += 1;

        emit Transfer(msg.sender, to, _tokenId);
    }

    // transferFrom

    function transferFrom(
        address from,
        address to,
        uint256 _tokenId
    ) public {
        require(_tokenId < tokenId, "DOES_NOT_EXIST");
        address previousOwner = ownerOf[_tokenId];
        require(previousOwner == from, "FROM_IS_NOT_OWNER");

        // caller should be owner

        // should have allowance for token
        // should have
        require(
            ownerOf[_tokenId] == msg.sender ||
                allowance[previousOwner][_tokenId] == msg.sender ||
                allAllowance[ownerOf[_tokenId]][msg.sender],
            "ACCESS_DENIED"
        );
        ownerOf[_tokenId] = to;
        balanceOf[msg.sender] -= 1;
        balanceOf[to] += 1;

        emit Transfer(from, to, _tokenId);

        emit NFTTransfered(from, to, tokenId, "");
    }

    //
    function safeTransferFrom(
        address from,
        address to,
        uint256 _tokenId
    ) external {
        // this will get the length of bytecode deployed for that address
        // 0 bytecode means Externally Owned Account.
        require(address(to).code.length == 0, "NOT_SAFE");
        transferFrom(from, to, _tokenId);

        emit NFTTransfered(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 _tokenId,
        bytes calldata data
    ) external {
        // this will get the length of bytecode deployed for that address
        // 0 bytecode means Externally Owned Account.
        require(address(to).code.length == 0, "NOT_SAFE");
        transferFrom(from, to, _tokenId);
        emit NFTTransfered(from, to, tokenId, data);
    }

    // approve

    function approve(address to, uint256 _tokenId) external {
        require(_tokenId < tokenId, "DOES_NOT_EXIST");
        require(ownerOf[_tokenId] == msg.sender, "NOT_OWNER");

        allowance[msg.sender][_tokenId] = to;
        emit Approval(msg.sender, to, _tokenId);
    }

    function setApprovalForAll(address operator, bool _approved) external {
        require(operator != address(0), "Invalid_address");

        allAllowance[msg.sender][operator] = _approved;
    }

    function getApproved(uint256 _tokenId)
        external
        view
        returns (address operator)
    {
        return allowance[ownerOf[_tokenId]][_tokenId];
    }

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool)
    {
        return allAllowance[owner][operator];
    }
}
