pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";
import "../interfaces/ISbFmERC20.sol";
import "../interfaces/IBorrower.sol";

contract SbFmERC20 is ERC20, ISbFmERC20 {

    uint256 public immutable cap;

    event FlashMint(address account, uint256 amount);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _amount,
        address token_holder
    ) public ERC20(_name, _symbol) {
        _mint(token_holder, _amount);
        cap = _amount;
    }

    function flashMint(uint256 amount) public override returns (bool) {
        _flashMint(msg.sender, amount);
        return true;
    }

    function _flashMint(address account, uint256 amount) internal virtual {
        _mint(account, amount);
        IBorrower(account).executeOnFlashMint(amount);
        _burn(account, amount); 
        assert(totalSupply() == cap);
        emit FlashMint(account, amount);
    }
}