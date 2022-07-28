// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NervosBridge is IERC20 {
    using SafeMath for uint256;

    address public usdtToken;
    address public usdcToken;
    address public busdToken;
    address public daiToken;
    address private _owner;

    event Received(address, uint256);

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 eachWalletMaxAmount = 1000 ether;
    uint256 eachWalletRequestAmount = 100 ether;
    uint256 _totalSupply;

    constructor(uint256 total) {
        _totalSupply = total;
        _owner = msg.sender;
        balances[msg.sender] = _totalSupply;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    // set up the total supply of the contract
    function totalSupply() public view returns (uint256) {
        return balances[msg.sender];
    }

    // return the balance of the address
    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    // transfer the balance to another address
    function transfer(address receiver, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender], "not enough tokens");
        //exchange the tokens
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        //add the event
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    // approve transfer the balance to another address
    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    //transferForm
    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    ) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[owner][delegate];
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
