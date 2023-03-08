// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {MergeNFTProxy} from "./MergeNFTProxy.sol";

import {IMergeNFTFactory} from "./interfaces/IMergeNFTFactory.sol";

import {MergeNFT} from "./MergeNFT.sol";


/// @title MergeNFT Factory 
/// @author matheus
contract MergeFactory is IMergeNFTFactory, OwnableUpgradeable, UUPSUpgradeable {

	/// @notice Address for implementation of MergeNFT to clone
	address public immutable implementation;
	

	constructor(address _implementation) initializer {
		if(_implementation == address(0)) revert AddressCannotBeZero();

		implementation = _implementation;
	}

	function initialize() external initializer {
		__Ownable_init();
		__UUPSUpgradeable_init();
	}

	function _authorizeUpgrade(address _newImplementation) internal override onlyOwner {}

	function createNewMergeNFT(
		string memory mergeNFTName,
		string memory mergeNFTSymbol,
		uint256 amountToMerge,
		address initialOwner,
		address renderer,
		IERC721 collectionToMerge
	) public payable returns (address newMergeNFTAddress) {
		MergeNFTProxy newMergeNFT = new MergeNFTProxy(implementation, "");

		newMergeNFTAddress = address(newMergeNFT);
		MergeNFT(newMergeNFTAddress).initialize({
			_mergeNFTName: mergeNFTName,
			_mergeNFTSymbol: mergeNFTSymbol,
			_amountToMerge: amountToMerge,
			_initialOwner: initialOwner,
			_renderer: renderer,
			_collectionToMerge: collectionToMerge
		});

		emit MergeNFTCreated({
			mergeNFT: newMergeNFTAddress,
			owner: initialOwner
		});

	}

}