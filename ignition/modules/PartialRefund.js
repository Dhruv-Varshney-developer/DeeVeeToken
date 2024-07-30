const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("PartialRefundModule", (m) => {
  const PartialRefund = m.contract("PartialRefund", [], {
    args: [],
  });

  return { PartialRefund };
});
