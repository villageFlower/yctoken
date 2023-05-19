// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public implementation;
    address public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    fallback() external payable {
        address _impl = implementation;

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)

            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }

    function upgrade(address _newImplementation) public onlyOwner {
        implementation = _newImplementation;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}