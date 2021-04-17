pragma solidity ^0.8.0;

interface IBorrower {
    function executeOnFlashMint(uint256 amount) external;
}