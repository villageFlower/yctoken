// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasToken {
    mapping(address => uint256) public balances;

    function mint(uint256 _amount) external returns (bool success) {
        require(_amount >= 0, "Amount must be greater than or equal to zero");
        balances[msg.sender] += _amount;
        return true;
    }

    function burn(uint256 _amount) external returns (bool success)  {
        require(_amount >= 0, "Amount must be greater than or equal to zero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        return true;
    }
}