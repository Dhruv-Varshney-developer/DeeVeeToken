const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("MyTokenModule", (m) => {
  const myToken = m.contract("MyToken", [], {
    args: [],
  });

  return { myToken };
});