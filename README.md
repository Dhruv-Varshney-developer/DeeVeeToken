# Advanced ERC20 Token Implementations

## 🔍 Overview

This project demonstrates multiple **ERC20 token** implementations with advanced features built using **Hardhat** and **OpenZeppelin**. Each implementation showcases different aspects of token functionality and security.

## 🛠 Technical Stack

- **Solidity** for smart contract development
- **Hardhat** as the development environment
- **OpenZeppelin** for secure, standard implementations
- **TypeScript** for testing
- **Prettier** & **Solhint** for code quality
- **Ignition** for deployment management

## 🚀 Key Features

1. **ERC20 with God Mode**:
Extends OpenZeppelin's ERC20 implementation with administrative controls:

- `mintTokensToAddress(address recipient, uint256 amount)` : Token minting capabilities with specified amounts
- `changeBalanceAtAddress(address target, uint256 amount)` : Direct balance manipulation functionality
- `authoritativeTransferFrom(address from, address to)` : Authoritative transfer mechanisms

2. ERC20 with Sanctions
Implements blacklisting functionality:

- Centralized authority can prevent addresses from sending/receiving tokens
- Secure blacklist management
- Integration with token transfer mechanisms

3. ERC20 with Token Sale
Features:

- Exchange rate: 1000 tokens per 1 ETH
- 18 decimal places precision
- Maximum supply cap of 1 million tokens
- ETH withdrawal functionality

4. ERC20 with Token Sale and Partial Refunds

Additional features:

- Users can sell back tokens at 0.5 ETH per 1000 tokens.
- Supports partial amounts.
- Maintains maximum supply of 1 million tokens.
- Requires contract ETH balance for refunds.
- Added unit tests with 100% Line Coverage and 90% Branch coverage.

## 🔧 Installation

```bash
npm install
```

## 💻 Usage

```bash
# Get help with available commands
npx hardhat help

# Run the test suite
npx hardhat test

# Run tests with gas reporting
REPORT_GAS=true npx hardhat test

# Start local node
npx hardhat node

# Deploy contracts
npx hardhat ignition deploy ./ignition/modules/Lock.js

# Format Solidity files
npx prettier --write --plugin=prettier-plugin-solidity "**/*.sol"
```

## 🧪 Testing

The repository includes comprehensive test suites for all implementations, with special focus on:
- Security scenarios
- Edge cases
- Access control validation
- Token economics verification
- 100% Line Coverage achievement
- 90% Branch Coverage achievement

## 🔐 Security Features

- Implementation of **OpenZeppelin** standard contracts
- Comprehensive access control mechanisms
- Input validation and safety checks
- Protection against integer overflow/underflow
- Secure ETH handling

## 🏗 Project Structure

```
├── contracts/
│   ├── PartialRefund.sol
│   └── MyToken.sol
├── test/
│   └── PartialRefund.js
├── ignition/
│   └── modules/
└── hardhat.config.js
```

## 📋 Development Practices

- Built on OpenZeppelin ERC20 implementation
- Code formatted with Solhint and Prettier
- Proper access controls implementation
- Avoids magic numbers
- Supports flexible token amounts using ratios
- Maintains 18 decimal places precision
- Uses **OpenZeppelin** utilities
- Implements required hooks like `_beforeTokenTransfer`.
## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.