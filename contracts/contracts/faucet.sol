// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

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
        address payable recipient = payable(msg.sender);

        //check the balance of this contract is enough to withdraw
        require(
            address(this).balance >= eachWalletMaxAmount,
            "not enough balance"
        );

        //check the limited of each wallet is enough to withdraw
        require(
            balances[msg.sender] <=
                eachWalletMaxAmount - eachWalletRequestAmount,
            "reached max amount"
        );

        //withdraw
        recipient.transfer(eachWalletRequestAmount);

        //update the balance of wallet
        balances[msg.sender] = balances[msg.sender] + eachWalletRequestAmount;
    }
}
