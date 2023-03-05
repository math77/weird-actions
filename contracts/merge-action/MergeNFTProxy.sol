// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract MergeNFTProxy is ERC1967Proxy {
	constructor(address _logic, bytes memory _data) payable ERC1967Proxy(_logic, _data) {}
}