// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "../FlashMintableERC20.sol";

contract Borrower {
    address owner;
    FlashMintableERC20 FlashToken;

    constructor (
        address _flashERC20, // address of the FlashERC20 contract
        address _owner
        ) {
            owner = _owner;
            FlashToken = FlashMintableERC20(_flashERC20);
        }

    function beginFlashMint(uint256 _amount) public {
        require(msg.sender == owner, "Borrower: only the owner can call this function!");
        FlashToken.flashMint(_amount);
    }

    function executeOnFlashMint(uint256 _amount) external returns (bool) {
        require(msg.sender == address(FlashToken), "only FlashToken can execute");

        // When this executes, this contract will have `amount` more FlashToken tokens.
        // Do whatever you want with those tokens here.
        // But you must make sure this contract holds at least `amount` FlashToken tokens before this function
        // finishes executing or else the transaction will be reverted by the `FlashERC20.flashMint` function.

        return true;
    }
}