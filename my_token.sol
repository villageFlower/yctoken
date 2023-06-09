// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// this is a contract with name MyToken
contract MyToken {
    string public name; //The name of the token
    string public symbol; //The symbol or ticker of the token
    uint8 public decimals; //The number of decimal places for the token
    uint256 public totalSupply; //The total supply of the token

    mapping(address => uint256) public balanceOf; //It maps addresses to their token balances.

    event Transfer(address indexed from, address indexed to, uint256 value);


    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**uint256(decimals);
        //the initial supply is multiplied by 10^decimals
        balanceOf[msg.sender] = totalSupply; //assign to the contract deployer's address
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {

        //check the balance of sender is larger or equal to value
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        //deduct the value from sender's balance
        balanceOf[msg.sender] -= _value;
        
        //add the value to receiver's balance
        balanceOf[_to] += _value;
        // emit the event
        emit Transfer(msg.sender, _to, _value);
        return true;
    }



}
