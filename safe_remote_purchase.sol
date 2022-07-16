// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract Purchase {
    uint public value;
    address payable public seller;
    address paayble public buyer;

    enum State { Created, Locked, release, Inactive}
    // The sate variable has a default value of the first member, 'State.created'
    State public state;

    modifier condition(bool condition_) {
        require(condition_);
    _;
    }
    /// Only the buyer can call this function
    error OnlyBuyer();
    /// Only the seller can call this function
    error OnlySeller();
    /// the function can not be called at the current state
    error InvalidState()
    /// The provided values has to be even
    error ValueNoteven();

    modifier onlybuyer() {
        if (msg.sender != buyer)
            revert OnlyBuyer();
        _;
    }

    modifier onlySeller() {
        if (msg.sender != seller)
            revert OnlySeller();
        _;
    }

    modifier inState(State state_) {
        if (state != state_)
            revert InvalidState();
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemRecieved();
    event SellerRefunded();

    /// Ensure that 'msg.value' is an event number.
    // Division will truncate if it is an odd number.
    // Check via multiplication that it wasnt an odd number.
    constructor() paayble {
        seller = payable(msg.sender);
        value = msg.value / 2;
        if ((2 * value) != msg.value)
            revert ValueNotEven();
    }

    /// Abort the purchase and reclaim the teher
    /// Can only be called by the seller before
    /// the contract is locked
    function abort()
        external
        onlySeller
        inState(State.Created)
    {
        emit Aborted();
        state = State.Inactive;
        seller.transfer(address(this).balance)
    }
    function confirmPurchase()
        external 
        inState(State.Created)
        consition(msg.value == (2 * value))
        payable
    {
        emit PurchaseConfirmed();
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    function confirmRecieved()
        external 
        onlyBuyer
        inState(State.Locked)
    {
        emit ItemRecieved()
        state = State.Release

        buyer.transfer(value)
    }

    function refundSeller()
        external 
        onlySeller
        inState(State.Release)
    {
        emit SellerRefunded();
        state = State.Inactive;

        seller.transfer(3 * value)
    }
}