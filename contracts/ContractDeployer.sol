// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./test/TestContractDeployer.sol";

error NotOwner();
error InsufficientAmount();
error LimitExceeded();
error OnlyEOA();

contract ContractDeployer {

    address public immutable owner;
    
    address[] public contracts;
    Addresses[] public getContractWithOwnerAddress;

    mapping (address => address) public getLatestContractAddressOfOwner;
    mapping (address => address) public getContractOwner;
    mapping (address => uint256) private _deployedContractsPerWallet;
    mapping (address => address[]) private _trackingContracts;

    struct Addresses {
        address contractOwner;
        address contractAddress;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Function to deploy user's contracts
     * @param contractsAmount Amount of desired contracts to be deployed, which can not be 0 and can not exceed 5
     */
    function deployContract(uint256 contractsAmount) external payable {
        uint256 maxContractsPerTx = 5;
        uint256 maxContractsPerWallet = 15;
        uint256 deploymentPrice = 0.005 ether;
        if (tx.origin != msg.sender) revert OnlyEOA();
        if (contractsAmount == 0 || contractsAmount > maxContractsPerTx) revert LimitExceeded();
        if (msg.value < contractsAmount * deploymentPrice) revert InsufficientAmount();
        if (_deployedContractsPerWallet[msg.sender] + contractsAmount > maxContractsPerWallet) revert LimitExceeded();
        _deployedContractsPerWallet[msg.sender] += contractsAmount;
        for (uint256 i; i < contractsAmount;) {
            TestContractDeployer deployedContract = new TestContractDeployer();
            getContractWithOwnerAddress.push(Addresses({contractOwner: msg.sender, contractAddress: address(deployedContract)}));
            _trackingContracts[msg.sender] = contracts;
            contracts.push(address(deployedContract));
            getLatestContractAddressOfOwner[msg.sender] = address(deployedContract);
            getContractOwner[address(deployedContract)] = msg.sender;
            unchecked {i++;}
        }
    }

    /**
     * @notice Function that returns a string of all deployed contracts of given address
     * @param ownerAddress Will return all deployed contracts of the given address in a string
     */
    function getStringOfOwnerContracts(address ownerAddress) external view returns (address[] memory) {
        return _trackingContracts[ownerAddress];
    }

    /**
     * @notice Function that enables only the owner to withdraw funds from contract
     */
    function withdraw() external {
        if (msg.sender != owner) revert NotOwner();
        payable(owner).transfer(address(this).balance);
    }
}
