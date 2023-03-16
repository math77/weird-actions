// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IMergeNFT} from "./interfaces/IMergeNFT.sol";


/// @title MergeNFT Storage 
/// @author matheus
abstract contract MergeNFTStorage {

  /// @notice TokenId of NFT minted after the merge
  uint256 public tokenId;

  /// @notice Storage configuration for NFT merge
  IMergeNFT.Configuration public config;

  /// @notice Keeps track of the merged tokens
  mapping(uint256 tokenId => bool merged) public tokensMerged;
  
}