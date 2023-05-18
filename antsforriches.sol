pragma solidity ^0.8.0;

contract AntsForRiches {

    string public name = "AntsForRiches";
    string public symbol = "AFR";
    uint256 public totalSupply = 200000000;
    uint8 public decimals = 18;

    address public owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(string memory n, string memory s) {
        name = n;
        symbol = s;
        totalSupply = 200000000 * 10**decimals;
        owner = msg.sender;
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

    function transfer(address to, uint256 amount) public returns(bool success) {
        require(amount > 0 && balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns(bool success) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns(uint256) {
        return allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint256 amount) public returns(bool success) {
        require(amount > 0 && allowances[from][msg.sender] >= amount);
        allowances[from][msg.sender] -= amount;
        balances[to] += amount;
        balances[from] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
