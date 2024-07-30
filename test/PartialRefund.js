const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PartialRefund", function () {
  let PartialRefund;
  let owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();

    const Partialrefund = await ethers.getContractFactory("PartialRefund");
    PartialRefund = await Partialrefund.deploy();
    await PartialRefund.waitForDeployment();

    // Get the contract address
    const PartialRefundAddress = await PartialRefund.getAddress();
    console.log("PartialRefund deployed to:", PartialRefundAddress);

    // Mint some tokens to addr1 for testing
    await PartialRefund.mintTokensToAddress(addr1.address, ethers.parseEther("1000"));
  });

  describe("sellBack", function () {
    it("Should revert if the amount is zero", async function () {
      await expect(PartialRefund.connect(addr1).sellBack(0)).to.be.revertedWith(
        "Amount must be greater than zero",
      );
    });

    it("Should revert if the contract does not have enough ether", async function () {
      await expect(PartialRefund.connect(addr1).sellBack(500)).to.be.revertedWith(
        "Contract does not have enough ether",
      );
    });

    it("Should sell back tokens and transfer ether", async function () {
      // First, fund the contract with some ether
      const PartialRefundAddress = await PartialRefund.getAddress();
      await PartialRefund
        .connect(owner)
        .buyTokens({ value: ethers.parseEther("10.0") });

      // Check initial balances
      const initialBalance = await ethers.provider.getBalance(addr1.address);
      const contractBalance = await ethers.provider.getBalance(PartialRefundAddress);

      console.log(
        "Contract balance before sellBack:",
        ethers.formatEther(contractBalance),
      );

      // addr1 sells back 500 tokens
      await PartialRefund.connect(addr1).sellBack(500);

      // Check final balances
      const finalBalance = await ethers.provider.getBalance(addr1.address);
      const newContractBalance =
        await ethers.provider.getBalance(PartialRefundAddress);

      // Verify that the contract balance decreased by the correct amount
      expect(newContractBalance).to.equal(
        contractBalance - ethers.parseEther("0.25"),
      ); // 0.25 ether for 500 tokens

      // Verify that addr1's balance increased by the correct amount (approximately)
      expect(finalBalance).to.be.closeTo(
        initialBalance + ethers.parseEther("0.25"),
        ethers.parseEther("0.01"), // Allow for gas fees
      );
    });
  });
});
