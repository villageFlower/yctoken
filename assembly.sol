// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// this is a contract with name MyToken
contract AssToken {
    string public name; //The name of the token
    string public symbol; //The symbol or ticker of the token
    uint8 public decimals; //The number of decimal places for the token
    uint256 public totalSupply; //The total supply of the token

    mapping(address => uint256) public balanceOf; //It maps addresses to their token balances.
    //It maps addresses to their approved spending allowances for other addresses.

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
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        bytes32 from_key = keccak256(abi.encodePacked(msg.sender));
        bytes32 to_key = keccak256(abi.encodePacked(_to));
        
        assembly {
            mstore(0x60, sload(from_key))

            if iszero(sub(mload(0x60), _value)) {
                revert(0, 0)
            }

            sstore(from_key, sub(mload(0x60),_value))
            sstore(to_key, add(sload(to_key), _value))

        }

        // emit the event
        emit Transfer(msg.sender, _to, _value);
        return true;
    }


}
