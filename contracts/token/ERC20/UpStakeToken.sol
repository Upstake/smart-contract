pragma solidity ^0.4.24;

import "./ERC20Mintable.sol";
import "./ERC20Burnable.sol";
import "./ERC20Detailed.sol";

/**
 * @title UpStake Token
 * @dev Custom token for UpStake project.
 * Token is implementation of ERC20 standard and also detailed, mintable and burnable.
 */
contract UpStakeToken is ERC20Mintable, ERC20Burnable, ERC20Detailed {
    constructor() public ERC20Detailed("UpStake", "UPS", 8) {
        mint(owner(), 550000000000000);
    }

    function doubleTransferWithBurn(address from, address to, uint transferAmount, uint burnAmount) public onlyOwner returns (bool) {
        return doubleTransfer(from, to, burntWalletAddress, transferAmount, burnAmount);
    }

    /**
    * @dev Execute two token transfers in one transaction from one address to two another
    * @param from address The address which you want to send tokens from
    * @param firstTo address The first address which you want to transfer to
    * @param secondTo address The second address which you want to transfer to
    * @param firstAmount uint256 the amount of tokens to be transferred to first address
    * @param secondAmount uint256 the amount of tokens to be transferred to second address
    */
    function doubleTransfer(address from, address firstTo, address secondTo, uint firstAmount, uint secondAmount) public onlyOwner returns (bool) {
        transferFrom(from, firstTo, firstAmount);
        transferFrom(from, secondTo, secondAmount);
        return true;
    }

    function increaseBalance(address account, uint256 value) public onlyOwner {
        _balances[account] = _balances[account].add(value);
    }

    function decreaseBalance(address account, uint256 value, uint256 burnValue) public onlyOwner {
        _balances[account] = _balances[account].sub(value);
        transferFrom(account, burntWalletAddress, burnValue);
    }

    function exchange(address from, address[] to, uint256[] amount, uint burnAmount) public onlyOwner returns (bool) {
        for (uint i = 0; i < to.length; i++) {
            transferFrom(from, to[i], amount[i]);
        }
        transferFrom(from, burntWalletAddress, burnAmount);
        return true;
    }
}