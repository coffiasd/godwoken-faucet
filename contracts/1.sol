// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NervosBridge {
    mapping(address => uint256) balances;
    
    uint256 maxAmount = 1000 ;

    using SafeMath for uint256;

    //reveive token from other contracts
    receive() payable external{} 

    function withDrawSomeToken(uint256 amount,address payable to) public {
        require(balances[msg.sender]<=maxAmount-amount);
        to.transfer(amount);
    }

}
