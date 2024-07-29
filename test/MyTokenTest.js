const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyToken", function () {
  let myToken;
  let owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();

    const MyToken = await ethers.getContractFactory("MyToken");
    myToken = await MyToken.deploy();
    await myToken.deployed();

    // Mint some tokens to addr1 for testing
    await myToken.mintTokensToAddress(addr1.address, 1000);
  });

  describe("sellBack", function () {
    it("Should revert if the amount is zero", async function () {
      await expect(myToken.connect(addr1).sellBack(0)).to.be.revertedWith("Amount must be greater than zero");
    });

    it("Should revert if the contract does not have enough ether", async function () {
      await expect(myToken.connect(addr1).sellBack(500)).to.be.revertedWith("Contract does not have enough ether");
    });

    it("Should sell back tokens and transfer ether", async function () {
      // First, fund the contract with some ether
      await owner.sendTransaction({
        to: myToken.address,
        value: ethers.utils.parseEther("1.0"), // Send 1 ether to the contract
      });

      // Check initial balances
      const initialBalance = await ethers.provider.getBalance(addr1.address);
      const contractBalance = await ethers.provider.getBalance(myToken.address);

      // addr1 sells back 500 tokens
      await myToken.connect(addr1).sellBack(500);

      // Check final balances
      const finalBalance = await ethers.provider.getBalance(addr1.address);
      const newContractBalance = await ethers.provider.getBalance(myToken.address);

      // Verify that the contract balance decreased by the correct amount
      expect(newContractBalance).to.equal(contractBalance.sub(ethers.utils.parseEther("0.25"))); // 0.5 ether for 500 tokens

      // Verify that addr1's balance increased by the correct amount
      expect(finalBalance).to.be.closeTo(initialBalance.add(ethers.utils.parseEther("0.25")), ethers.utils.parseEther("0.01")); // Allow for gas fees
    });
  });
});