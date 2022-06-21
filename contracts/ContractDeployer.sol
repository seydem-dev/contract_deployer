// SPDX-License-Identifier: MIT

/// @title A contract that deploys other contracts with additional functionality and restrictions
/// @author Seyon Demiroglu

pragma solidity ^0.8.0;

import "./Contract.sol";
import "./AggregatorV3Interface.sol";

contract ContractDeployer {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    address[] public storeContracts;
    Addresses[] public contracts;

    mapping(address => address) public getLatestContractAddress;
    mapping(address => address) public getEOA;
    mapping(address => uint8) private _deployedContractsPerWallet;
    mapping(address => address[]) public trackingContracts;

    struct Addresses {
        address contractOwner;
        address contractAddress;
    }

    function deployContract(uint256 contractsAmount) external payable {
        require(tx.origin == msg.sender, "The function caller is not an Externally Owned Account");
        uint8 maxContractsPerTx = 5;
        uint8 maxContractsPerWallet = 50;
        uint56 deploymentPrice = 0.005 ether;
        require(contractsAmount != 0 && contractsAmount <= maxContractsPerTx, "You can not deploy more than 5 contracts per transaction");
        require(msg.value == contractsAmount * deploymentPrice, "You need to pay 0.005 ETH per contract");
        require(_deployedContractsPerWallet[msg.sender] + contractsAmount <= maxContractsPerWallet, "You can not deploy more than 50 contracts per wallet");
        for(uint256 i = 0; i < contractsAmount; i++) {
            Contract deployedContract = new Contract();
            contracts.push(Addresses({contractOwner: msg.sender, contractAddress: address(deployedContract)}));
            storeContracts.push(address(deployedContract));
            trackingContracts[msg.sender] = storeContracts;
            getLatestContractAddress[msg.sender] = address(deployedContract);
            getEOA[address(deployedContract)] = msg.sender;

        }
    }

    /**
     * @notice Enables owner to withdraw funds from contract
     */
    function withdraw() external payable {
        require(msg.sender == owner, "You are not the owner of this contract");
        payable(owner).transfer(address(this).balance);
    }

    /**
     * @notice Returns a list of all deployed contracts of an EOA
     */
    function getOwnerContracts(address ownerAddress) external view returns (address[] memory) {
        return trackingContracts[ownerAddress];
    }
}
