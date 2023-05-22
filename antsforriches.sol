pragma solidity ^0.8.0;

// MIT License
// SPDX-License-Identifier: MIT

contract AntsForRiches {
  
  string public name = "AntsForRiches"; // Name: AntsForRiches
  string public symbol = "A4Riches"; // Symbol name is now: A4Riches

  // Website: www.antsforriches.com
  // GitHub: https://github.com/m1xmstr/AntsForRiches
  // Twitter: https://twitter.com/AntsForRiches
  // Telegram: https://t.me/+kQMuwnGC67BiOTRh

  uint256 public totalSupply; // Total Supply: 250000000
  uint8 public decimals = 18; // Decimals: 18

  address public owner = 0x79a621261FB4CA9a45E118E2740b42dDB6C640d3; // Owner

  mapping(address => uint256) public balances; // Balances
  mapping(address => mapping(address => uint256)) public allowances; // Allowances

  event Transfer(address indexed from, address indexed to, uint256 amount);
  event Approval(address indexed owner, address indexed spender, uint256 amount);

  constructor() {
    totalSupply = 250000000 * 10**uint256(decimals);
    balances[owner] = totalSupply;
    emit Transfer(address(0), owner, totalSupply);
  }

  function mint(address to, uint256 amount) public onlyOwner {
    require(amount > 0);
    balances[to] += amount;
    totalSupply += amount;
    emit Transfer(address(0), to, amount);
  }

  function burn(uint256 amount) public onlyOwner {
    require(amount > 0 && balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;
    totalSupply -= amount;
    emit Transfer(msg.sender, address(0), amount);
  }

  function transfer(address to, uint256 amount) public returns (bool success) {
    require(amount > 0 && balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
    return true;
  }

  function approve(address spender, uint256 amount) public returns (bool success) {
    allowances[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }

  function allowance(address tokenOwner, address spender) public view returns (uint256) {
    return allowances[tokenOwner][spender];
  }

  function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
    require(amount > 0 && allowances[from][msg.sender] >= amount);
    allowances[from][msg.sender] -= amount;
    balances[to] += amount;
    balances[from] -= amount;
    emit Transfer(from, to, amount);
    return true;
  }

  function balanceOf(address account) public view returns (uint256) {
    return balances[account];
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
}
