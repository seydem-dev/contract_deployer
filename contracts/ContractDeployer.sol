// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Contract.sol";

contract ContractDeployer {

    address public immutable owner = msg.sender;
    
    address[] public contracts;
    Addresses[] public getContractWithOwnerAddress;

    mapping(address => address) public getLatestContractAddressOfOwner;
    mapping(address => address) public getContractOwner;
    mapping(address => uint8) private _deployedContractsPerWallet;
    mapping(address => address[]) private _trackingContracts;

    struct Addresses {
        address contractOwner;
        address contractAddress;
    }

    /**
     * @notice Function to deploy user's contracts
     * @param contractsAmount Amount of desired contracts to be deployed, which can not be 0 and can not exceed 5
     */
    function deployContract(uint8 contractsAmount) external payable {
        uint8 maxContractsPerTx = 5;
        uint8 maxContractsPerWallet = 50;
        uint56 deploymentPrice = 0.005 ether;
        require(tx.origin == msg.sender, "Only EOA");
        require(contractsAmount != 0 && contractsAmount <= maxContractsPerTx, "Max 5 contracts per tx");
        require(msg.value >= contractsAmount * deploymentPrice, "At least 0.005 ETH per contract");
        require(_deployedContractsPerWallet[msg.sender] + contractsAmount <= maxContractsPerWallet, "Max 50 contracts per EOA");
        _deployedContractsPerWallet[msg.sender] += contractsAmount;
        for (uint8 i; i < contractsAmount;) {
            Contract deployedContract = new Contract();
            getContractWithOwnerAddress.push(Addresses({contractOwner: msg.sender, contractAddress: address(deployedContract)}));
            _trackingContracts[msg.sender] = contracts;
            contracts.push(address(deployedContract));
            getLatestContractAddressOfOwner[msg.sender] = address(deployedContract);
            getContractOwner[address(deployedContract)] = msg.sender;
            unchecked { i++; }
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
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
