// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NervosBridge {
    event Received(address, uint);

    mapping(address => uint256) balances;
    
    uint256 maxAmount = 1000 ;

    //reveive token from other contracts
    receive() payable external{
        emit Received(msg.sender,msg.value);
    } 

    //withdraw token with limited amount
    function withDrawSomeToken(uint256 amount,address payable to) public {
        require(balances[msg.sender]<=maxAmount-amount,"reach max amount");
        to.transfer(amount);
    }

}
