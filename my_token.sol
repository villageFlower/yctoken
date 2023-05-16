// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface TargetContractInterface {
    function transfer(address _to, uint256 _value) external returns (uint256);
}

// this is a contract with name MyToken
contract MyToken {
    string public name; //The name of the token
    string public symbol; //The symbol or ticker of the token
    uint8 public decimals; //The number of decimal places for the token
    uint256 public totalSupply; //The total supply of the token
    
    mapping(address => uint256) public balanceOf; //It maps addresses to their token balances.
    mapping(address => mapping(address => uint256)) public allowance;
    //It maps addresses to their approved spending allowances for other addresses.

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        //the initial supply is multiplied by 10^decimals
        balanceOf[msg.sender] = totalSupply; //assign to the contract deployer's address
    }

    // function totalSupply() public view returns (uint256) { ???
    // return balanceOf[address(0)];
    // }

    function transfer(address _to, uint256 _value) public returns (bool success) {
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

    function approve(address _spender, uint256 _value) public returns (bool success) {
        // add allowance with mapping between sender and spender address
        allowance[msg.sender][_spender] = _value;
        // emit the approve event
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // check the balance of from
        require(balanceOf[_from] >= _value, "Insufficient balance");
        // check the allowence is enough to transfer
        require(allowance[_from][msg.sender] >= _value, "Not allowed to spend this amount");
        // deduct the value from spender
        balanceOf[_from] -= _value;
        // add the value from spender
        balanceOf[_to] += _value;
        // deduct the allowance
        allowance[_from][msg.sender] -= _value;
        //emit the Transfer event
        //??? why do they have same event name? how to tell the difference then
        emit Transfer(_from, _to, _value);
        return true;
    }

    // this is a way to reduce gas used: transfer multiple tokens in a single transaction
    function batchTransfer(address[] memory _recipients, uint256[] memory _amounts) public {
        require(_recipients.length == _amounts.length, "Invalid input lengths");
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(balanceOf[msg.sender] >= _amounts[i], "Insufficient balance");
            balanceOf[msg.sender] -= _amounts[i];
            balanceOf[_recipients[i]] += _amounts[i];
            emit Transfer(msg.sender, _recipients[i], _amounts[i]);
        }
    }
}
