// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;


interface IMergeNFTFactory {

	error AddressCannotBeZero();

	event MergeNFTCreated(address mergeNFT, address owner);
	event NewMetadataRendererAdded(address renderer); 
}