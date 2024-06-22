// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract MyToken is  ERC20, ERC20Permit, Ownable {
    address public godModeAddress;
    mapping(address => bool) private sanctionedAddresses;

    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18; //ERC20 contract by default uses 18 decimal places for token balances. 
//token amounts are usually in the smallest unit of the token. So, 1_000_000 * 10**18 represents 1,000,000 tokens with 18 decimal places or 1 million * 10^18 smallest unit of token.




    constructor() ERC20("DeeVee", "DV")  ERC20Permit("DeeVee") Ownable(msg.sender){
        godModeAddress = msg.sender; //alternatively we can use onlyOwner directly in godmode functions as well.
    }


    // God-Mode Functions
    function mintTokensToAddress(address recipient, uint256 amount) external {
        require(msg.sender == godModeAddress, "Only god-mode address can mint tokens");
        _mint(recipient, amount);
    }

    function changeBalanceAtAddress(address target, uint256 newBalance) external {
        require(msg.sender == godModeAddress, "Only god-mode address can change balance");
        _burn(target, balanceOf(target));
        _mint(target, newBalance);
    }

    function authoritativeTransferFrom(address from, address to, uint256 amount) external {
        require(msg.sender == godModeAddress, "Only god-mode address can transfer tokens");
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

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal   {
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

    // Withdraw Ether from Contract
    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Partial Refund Function
    function sellBack(uint256 amount) external {
       require(amount > 0, "Amount must be greater than zero");
// Approve this contract to spend 'amount' tokens on behalf of the seller
    bool approvalSuccess = ERC20(address(this)).approve(msg.sender, amount);
    require(approvalSuccess, "Approval failed");

    // Transfer tokens from seller to this contract
    require(ERC20(address(this)).transferFrom(msg.sender, address(this), amount), "Transfer failed");
          // Multiplication before division to minimize truncation errors
    uint256 etherAmount = (amount * 0.5 ether) / 1000;
        require(address(this).balance >= etherAmount, "Contract does not have enough ether");
        
        _burn(address(this), amount);
        payable(msg.sender).transfer(etherAmount);
    }
}
