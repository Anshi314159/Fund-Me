## Foundry Fund Me

**Foundry Fund Me is a decentralized crowdfunding platform built using Foundry.**


## Installations
- [git](https://git-scm.com/)
- [foundry](https://getfoundry.sh/)
- [Ganache](https://trufflesuite.com/ganache/)
  - If you want to deploy your smart contract on local chain

### Dependencies
- Chainlink Brownie Contracts
```shell
$ forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit 
```

- Foundry-DevOps
```shell
$ forge install cyfrin/foundry-devops@0.0.11 --no-commit
```

- Forge-std
```shell
$ forge install foundry-rs/forge-std@v1.5.3 --no-commit
```



## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```
### Deploy

- your_private_key: The private key of your account (like from metamask). NOTE: FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
- your_rpc_url: This is url of the sepolia testnet node you're working with or local anvil or ganache node. You can get setup with one for free from Alchemy.

```shell
$ forge script script/DeployFundMe.s.sol:FundMe --rpc-url <your_rpc_url> --private-key <your_private_key> --broadcast
```

## Format
- to format :

```shell
$ forge fmt
```

## Gas Snapshots
- you'll see an output file called ```.gas-snapshot```
```shell
$ forge snapshot
```

## Anvil
- to run anvil

```shell
$ anvil
```


## Thank You
Special thanks to [Patrick Collins](https://github.com/PatrickAlphaC) for his invaluable teaching and mentoring.