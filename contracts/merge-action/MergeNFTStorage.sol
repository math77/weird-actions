// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


/// @title MergeNFT Storage 
/// @author matheus
abstract contract MergeNFTStorage {

  /// @notice Address of the origin collection of the NFTs to merge
  IERC721 public collectionToMerge;

  /// @notice TokenId of NFT minted after the merge
  uint256 public tokenId;

  /// @notice Amount of tokens to merge in order to mint new one
  uint256 public amountToMerge;

  /// @notice Keeps track of the merged tokens
  mapping(uint256 tokenId => bool merged) public tokensMerged;
  
}