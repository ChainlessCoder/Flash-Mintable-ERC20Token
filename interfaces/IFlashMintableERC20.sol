// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface IFlashMintableERC20 {
    function flashMint(uint256 _amount) external returns (bool);

    event FlashMint(address account, uint256 amount);
}