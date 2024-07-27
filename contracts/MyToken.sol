// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Permit, Ownable {
    mapping(address => bool) private sanctionedAddresses;

    uint256 public constant MAX_SUPPLY = 1_000_000 * 10 ** 18; //ERC20 contract by default uses 18 decimal places for token balances.
    //token amounts are usually in the smallest unit of the token. So, 1_000_000 * 10**18 represents 1,000,000 tokens with 18 decimal places or 1 million * 10^18 smallest unit of token.

    constructor()
        ERC20("DeeVee", "DV")
        ERC20Permit("DeeVee")
        Ownable(msg.sender)
    {}

    // God-Mode Functions
    function mintTokensToAddress(
        address recipient,
        uint256 amount
    ) external onlyOwner {
        _mint(recipient, amount);
    }

    function changeBalanceAtAddress(
        address target,
        uint256 newBalance
    ) external onlyOwner {
        _burn(target, balanceOf(target));
        _mint(target, newBalance);
    }

    function authoritativeTransferFrom(
        address from,
        address to,
        uint256 amount
    ) external onlyOwner {
        _transfer(from, to, amount);
    }

    // Sanction Functions
    function addSanction(address account) external onlyOwner {
        sanctionedAddresses[account] = true;
    }

    function removeSanction(address account) external onlyOwner {
        sanctionedAddresses[account] = false;
    }

    function isSanctioned(address account) public view returns (bool) {
        return sanctionedAddresses[account];
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(!sanctionedAddresses[from], "Sender is sanctioned");
        require(!sanctionedAddresses[to], "Receiver is sanctioned");
        super._update(from, to, amount);
    }

    // Token Sale Function
    function buyTokens() external payable {
        uint256 amount = msg.value * 1000; // This calculates the amount in token smallest units
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds maximum supply");
        _mint(msg.sender, amount); // This mints the tokens in smallest units
    }

    // View function to see how much Ether can be withdrawn
    function withdrawableEther() public view returns (uint256) {
        uint256 requiredEtherForSellBack = (totalSupply() * 5) / 10000;
        if (address(this).balance > requiredEtherForSellBack) {
            return address(this).balance - requiredEtherForSellBack;
        } else {
            return 0;
        }
    }

    // Withdraw Ether from Contract
    function withdrawFunds(uint256 amount) external onlyOwner {
        uint256 maxWithdrawable = withdrawableEther();
        require(amount <= maxWithdrawable, "Amount exceeds withdrawable limit");
        payable(owner()).transfer(amount);
    }

    // Partial Refund Function
    function sellBack(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        uint256 etherAmount = (amount * 0.5 ether) / 1000;
        require(
            address(this).balance >= etherAmount,
            "Contract does not have enough ether"
        );

        _burn(msg.sender, amount);
        payable(msg.sender).transfer(etherAmount);
    }
}
