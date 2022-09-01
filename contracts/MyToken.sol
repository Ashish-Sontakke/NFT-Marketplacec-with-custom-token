// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./interfaces/IERC20.sol";

contract MyToken is IERC20 {
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    uint8 public decimals = 18;
    string name = "MyToken";
    string symbol = "MT";

    // owner => sepner => hou much he can spend;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 initialBalance) {
        totalSupply = initialBalance;
        balanceOf[msg.sender] == initialBalance;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "INVALID_ADDRESS");
        require(amount > 0, "INVALID_AMOUNT");

        require(balanceOf[msg.sender] >= amount, "INSUFFICIENT_BALANCE");

        balanceOf[to] += amount;
        balanceOf[msg.sender] -= amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "INVALID_ADDRESS");
        require(amount > 0, "INVALID_AMOUNT");

        allowance[msg.sender][spender] += amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(to != address(0), "INVALID_ADDRESS");
        require(amount > 0, "INVALID_AMOUNT");
        require(allowance[from][msg.sender] > amount, "INSUFFICIENT_ALLOWANCE");
        require(balanceOf[from] >= amount, "INSUFFICIENT_BALANCE");

        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }
}
