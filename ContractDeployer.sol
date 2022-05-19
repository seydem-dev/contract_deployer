// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./DeployedContract.sol";
import "@seydem-dev/used_chainlink/AggregatorV3Interface.sol";

contract ContractDeployer {

    address owner;

    DeployedContract deployedContract = new DeployedContract();

    DeployedContract[] public deployedContracts;

    mapping(address => address) contractOwnerToContractAddress;
    mapping(address => address) contractAddressToContractOwner;
    mapping(uint256 => mapping(address => address)) arrayIndexToContractAddressAndOwner;
    
    constructor() {
        owner = msg.sender;
    }

    /**
     * Mandatory for deployContract()
     */
    function getEthPrice() public view returns (uint256) { 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer) * 10000000000;
    }

    /**
     * Mandatory for deployContract()
     */
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPriceInWei = getEthPrice();
        uint256 ethAmountInUsd = (ethPriceInWei * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    function deployContract() public payable {
        uint256 minimumUsd = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUsd, "Error: You need to spend at least $50 to deploy your contract");
        deployedContracts.push(deployedContract);
    }

    //input: contract address
    //output: owner address of contract
    function getOwner(address contractAddress) public view returns (address) {
        contractAddressToContractOwner[contractAddress] = msg.sender(deployedContract);
    }

    //input: owner address
    //output: owned contract address(es)
    function getContract(address contractOwnerAddress) public view {
        contractOwnerToContractAddress[contractOwnerAddress] = address(deployedContract);
    }

    //input: index (0-∞) 
    //output: contract and owner address at that index
    function getOwnerAndContract(uint256 arrayIndex) public view {
        arrayIndexToContractAddressAndOwner[arrayIndex] = arrayIndexToContractAddressAndOwner[address(deployedContract)] = msg.sender(deployedContract);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Error: You are not the owner of this contract");
        _;
    }

    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}