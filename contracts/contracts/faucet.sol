// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NervosBridge {
    event Received(address, uint256);

    mapping(address => uint256) balances;

    uint256 eachWalletMaxAmount = 1000;
    uint256 eachWalletRequestAmount = 10;

    //reveive token from other contracts
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    //withdraw token with limited amount
    function withDrawSomeToken() public {
        require(
            balances[msg.sender] <=
                eachWalletMaxAmount - eachWalletRequestAmount,
            "reached max amount"
        );
        msg.sender.transfer(amount);
        balances[msg.sender] = balances[msg.sender] + eachWalletRequestAmount;
    }
}
