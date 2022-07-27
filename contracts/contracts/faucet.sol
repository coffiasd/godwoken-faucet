// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NervosBridge {
    address public usdtToken;
    address public usdcToken;
    address public busdToken;
    address public daiToken;
    address public owner;

    event Received(address, uint256);

    mapping(address => uint256) balances;

    uint256 eachWalletMaxAmount = 1000 ether;
    uint256 eachWalletRequestAmount = 100 ether;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setUsdtToken(address _usdtToken) external onlyOwner {
        // to set token address
        usdtToken = _usdtToken;
    }

    function setUsdcToken(address _usdcToken) external onlyOwner {
        // to set token address
        usdcToken = _usdcToken;
    }

    function setBusdToken(address _busdToken) external onlyOwner {
        // to set token address
        busdToken = _busdToken;
    }

    function setDaiToken(address _daiToken) external onlyOwner {
        // to set token address
        daiToken = _daiToken;
    }

    //reveive token from other contracts
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    //withdraw token with limited amount
    function withDrawSomeToken() public {
        //check the balance of this contract is enough to withdraw
        require(
            address(this).balance > eachWalletRequestAmount,
            "not enough balance"
        );

        //check the limited of each wallet is enough to withdraw
        require(
            balances[msg.sender] <=
                eachWalletMaxAmount - eachWalletRequestAmount,
            "reached max amount"
        );

        //withdraw
        payable(msg.sender).transfer(eachWalletRequestAmount);

        //update the balance of wallet
        balances[msg.sender] = balances[msg.sender] + eachWalletRequestAmount;
    }

    function requestusdtToken(uint256 amount) external payable virtual {
        require(
            balances[msg.sender] <=
                eachWalletMaxAmount - eachWalletRequestAmount,
            "reached max amount"
        );

        //starting to withdraw
        IERC20(usdtToken).transfer(msg.sender, amount);

        //update the balance of wallet
        balances[msg.sender] = balances[msg.sender] + eachWalletRequestAmount;
    }

    function requestusdcToken(uint256 amount) external payable virtual {
        require(
            balances[msg.sender] <=
                eachWalletMaxAmount - eachWalletRequestAmount,
            "reached max amount"
        );

        //starting to withdraw
        IERC20(usdcToken).transfer(msg.sender, amount);

        //update the balance of wallet
        balances[msg.sender] = balances[msg.sender] + eachWalletRequestAmount;
    }

    function requestbusdToken(uint256 amount) external payable virtual {
        require(
            balances[msg.sender] <=
                eachWalletMaxAmount - eachWalletRequestAmount,
            "reached max amount"
        );

        //starting to withdraw
        IERC20(busdToken).transfer(msg.sender, amount);

        //update the balance of wallet
        balances[msg.sender] = balances[msg.sender] + eachWalletRequestAmount;
    }

    function requestdaiToken(uint256 amount) external payable virtual {
        require(
            balances[msg.sender] <=
                eachWalletMaxAmount - eachWalletRequestAmount,
            "reached max amount"
        );

        //starting to withdraw
        IERC20(daiToken).transfer(msg.sender, amount);

        //update the balance of wallet
        balances[msg.sender] = balances[msg.sender] + eachWalletRequestAmount;
    }
}
