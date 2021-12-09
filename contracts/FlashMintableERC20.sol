// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../interfaces/IFlashMintableERC20.sol";
import "../interfaces/IBorrower.sol";

contract FlashMintableERC20 is ERC20, IFlashMintableERC20 {

    uint256 public immutable cap;
    uint256 private unlocked = 1;

    modifier nonReentrant() {
        require(unlocked == 1, 'Flash ERC20: Locked');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    constructor(uint256 _initialSupply) public ERC20("Flash", "FLASH") {
        _mint(msg.sender, _initialSupply);
        cap = _initialSupply;
    }

    function _flashMint(address _account, uint256 _amount) private {
        require(_account != address(0), "Flash ERC20: Mint to the zero address");
        _mint(_account, _amount);
        emit Transfer(address(0), _account, _amount);
    }

    // Allows anyone to mint the token as long as the same amount gets burned by the end of the transaction.
    function flashMint(uint256 _amount) external override nonReentrant returns (bool) {
        // mint tokens
        _flashMint(msg.sender, _amount);

        // hand control to borrower
        IBorrower(msg.sender).executeOnFlashMint(_amount);

        // burn tokens
        _burn(msg.sender, _amount); // reverts if `msg.sender` does not have enough tokens to burn

        // double-check that all minted tokens have been burned
        assert(cap == totalSupply());

        emit FlashMint(msg.sender, _amount);
    }
}