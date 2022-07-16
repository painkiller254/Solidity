// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract CryptoKids {
    // Owner Dad
    address owner;

    event logKidFundingRecieved(address addr, uint amount, uint contractBalance)

    constructor() {
        owner = msg.sender;
    }

    struct Kid {
        address walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }


    Kid[] public kids;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner can add kids");
        _;
    }

    function addKid(address walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public {
        kids.push(Kid(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

    
    function balanceOf() public view returns(uint){
        return address(this).balance;
    }

    // Define kid

    // Add kid to contract

    // deposit funds to contract, specifically kid's account
    function deposit(address walletAddress) payable public {
        addToKidsBalance(walletAddress);
    }

    function addToKidsBalance(address walletAddress) private onlyOwner{
        for(uint i = 0; i < kids.length; i++){
            if(kids[i].walletAddress == walletAddress) {
                kids[i].amount += msg.value;
                emit logKidFundingRecieved(walletAddress, msh.value, balanceOf());
            }
        }
    }

    function getIndex(address walletAddress) view private returns (uint) {
        for(uint i=0; i < kids.length; i++) {
            if(kids[i].walletAddress = walletAddress){
                return i;
            }
        }
        return 999;
    }

    function availableForWithdrawal(address walletAddress) public returns(bool){
        uint i = getIndex(walletAddress);
        require(block.timestamp > kids.releaseTime, "you can not withdraw yet");
        if (block.timestamp > kids[i].releaseTime){
            kids[i].canwithdraw = true;
            return true;
        } else {
            return false
        }
    }

    function withdraw(address payable walletAddress) payable public {
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw")
        require(kids[i].canWithdraw == true, "you are not eligible to withdraw")
        kids[i].walletAddress.transfer(kids[i].amount)
    }
    // kid checks if able to withdraw

    // Withdraw money
}

