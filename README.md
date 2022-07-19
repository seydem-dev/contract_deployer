# Contract Deployer
**Contract Deployer is a contract which deploys imported contracts under certain conditions and restrictions. In this case, the deployed contract is `TestContractDeployer.sol`, a sample contract. But really, any contract can be deployed, regardless of what it may represent.**

```
owner
```
*Address which deployed `ContractDeployer.sol`*

```
contracts
```
*Array of deployed contracts' addresses.*

```
getContractWithOwnerAddress
```
*Array that returns contract address and owner of that contract at the same index.*

```
getLatestContractAddressOfOwner
```
*Retrieve latest deployed contract address of some user.*

```
getContractOwner
```
*Array that returns contract's owner address.*

```
_deployedContractsPerWallet
```
*Mapping that is required so that address' deployed contracts amount can be tracked and limited.*

```
_trackingContracts
```
*Required for `getStringOfOwnerContracts()`*

```
Addresses
```
*Struct required to get contract address and contract deployer address in an array at the same index.*

```
deployContract()
```
*Function that deploys contract. Caller must be an EOA, user can not deploy more than 5 contracts per transaction, user can not deploy more than 50 contracts per EOA, user must pay 0.005 ETH / contract.*

```
getStringOfOwnerContracts()
```
*Get a string with the entirety of deployed contracts of an address.*

```
withdraw()
```
*Function for the owner to withdraw balance of the smart contract.*

# Test Contract Deployer

```
sample()
```
*Sample function returns a string. No more.*
