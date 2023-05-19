pragma solidity ^0.8.0;

// MIT License
// SPDX-License-Identifier: MIT

contract AntsForRiches {

  // Name: AntsForRiches
  string public name;

  // Website: www.antsforriches.com
  // GitHub: https://github.com/m1xmstr/AntsForRiches

  // Total Supply: 250000000
  uint256 public totalSupply;

  // Symbol name is now: A4R
  string public symbol;

  // Decimals: 18
  uint8 public decimals = 18;

  // Owner
  address public owner = 0x79a621261FB4CA9a45E118E2740b42dDB6C640d3;

  // Balances
  mapping(address => uint256) public balances;

  // Allowances
  mapping(address => mapping(address => uint256)) public allowances;

  // Events
  event Transfer(address indexed from, address indexed to, uint256 amount);
  event Approval(address indexed owner, address indexed spender, uint256 amount);

  // Constructor
  // This function creates the token and initializes the initial supply.
  constructor(string memory n, string memory s) {
    name = n;
    symbol = s;
    totalSupply = 250000000 * 10**uint256(decimals);
    balances[owner] = totalSupply;
    emit Transfer(address(0), owner, totalSupply);
  }

  // Mint
  function mint(address to, uint256 amount) public onlyOwner {
    require(amount > 0);
    balances[to] += amount;
    totalSupply += amount;
    emit Transfer(address(0), to, amount);
  }

  // Burn
  function burn(uint256 amount) public onlyOwner {
    require(amount > 0 && balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;
    totalSupply -= amount;
    emit Transfer(msg.sender, address(0), amount);
  }

  // Transfer
  function transfer(address to, uint256 amount) public returns (bool success) {
    require(amount > 0 && balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
    return true;
  }

  // Approve
  function approve(address spender, uint256 amount) public returns (bool success) {
    allowances[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }

  // Allowance
  function allowance(address tokenOwner, address spender) public view returns (uint256) {
    return allowances[tokenOwner][spender];
  }

  // TransferFrom
  function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
    require(amount > 0 && allowances[from][msg.sender] >= amount);
    allowances[from][msg.sender] -= amount;
    balances[to] += amount;
    balances[from] -= amount;
    emit Transfer(from, to, amount);
    return true;
  }

  // OnlyOwner modifier
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

}
