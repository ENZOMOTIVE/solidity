pragma solidity >=0.8.7 <0.9.0;

contract subforMore{
uint256 balance;
address sender;

 receive() external payable{
    sender = msg.sender; //address of user sending the contract not address of contract of developer
    balance = msg.value;
}
function getsender() public view returns(address){
return sender;

}
function getbalance() public view returns(uint256)
{
    return balance;
}
}
