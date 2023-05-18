// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AntsForRiches {
    string public name = "AntsForRiches";
    string public symbol = "AFR";
    address public owner = 0x79a621261FB4CA9a45E118E2740b42dDB6C640d3;

    uint256 private _totalSupply = 100000000 * 10**18; // 100 million AFR
    uint256 private _taxPercentage = 1;
    address private _burnAddress;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        _balances[msg.sender] = _totalSupply;
        _burnAddress = address(0);
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        uint256 taxAmount = (amount * _taxPercentage) / 100;
        uint256 transferAmount = amount - taxAmount;

        _balances[msg.sender] -= amount;
        _balances[recipient] += transferAmount;
        _balances[_burnAddress] += taxAmount;

        emit Transfer(msg.sender, recipient, transferAmount);
        emit Transfer(msg.sender, _burnAddress, taxAmount);

        return true;
    }

    function allowance(address _owner, address spender) public view returns (uint256) {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");
        require(_balances[sender] >= amount, "Insufficient balance");
        require(_allowances[sender][msg.sender] >= amount, "Allowance exceeded");

        uint256 taxAmount = (amount * _taxPercentage) / 100;
        uint256 transferAmount = amount - taxAmount;

        _balances[sender] -= amount;
        _balances[recipient] += transferAmount;
        _balances[_burnAddress] += taxAmount;
        _allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, transferAmount);
        emit Transfer(sender, _burnAddress, taxAmount);

        return true;
    }
}
