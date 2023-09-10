 pragma solidity ^0.8.0;

contract SimpleWallet {

    address public owner = msg.sender;  

    struct Allowance {
        uint amount;
        uint lastModified;
    }

    mapping(address => Allowance) public allowances;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier allowedToWithdraw(uint _amount) {
        require(isOwner() || getAllowance(msg.sender) >= _amount, "Withdrawal amount exceeds allowance");
        _;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == owner;
    }

    function setAllowance(address _who, uint _amount) public onlyOwner {
        allowances[_who] = Allowance(_amount, block.timestamp);
    }

    function getAllowance(address _who) public view returns(uint) {
        return allowances[_who].amount;
    }

    function deposit() public payable {}

    function withdraw(uint _amount) public allowedToWithdraw(_amount) {
        require(address(this).balance >= _amount, "Contract doesn't have enough funds");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        payable(msg.sender).transfer(_amount);
    }

    function reduceAllowance(address _who, uint _amount) internal {
        allowances[_who].amount -= _amount;
        allowances[_who].lastModified = block.timestamp;
    }

    function checkBalance() public view returns(uint) {
        return address(this).balance;
    }
}
