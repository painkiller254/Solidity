// SPDX-License-Identifier GPL-3.0
pragma solidity 0.8.4


contract Coin {
    address public miner;
    mapping (address => uint);
    public balances

    event Sent(address from, address to, uint amount);

    contructor() {
        minter = msg.Sender
    }

    function mint(address reciever, uint amount) public {
        require(msg.Sender == minter)
        balances[reciever] += amount
    }

    error InsufficientBalance(uint requested, uint available)

    function send(address reciever, uint amount) public {
        if (amount > balances[msg.Sender]) revert InsufficientBalance({
            requested: amount,
            available: balances[msg.sender]
        })

        balances[msg.sender] -= amount
        balances[reciever] += amount emit Sent(msg.Sender, reciever, amount)
    }
}