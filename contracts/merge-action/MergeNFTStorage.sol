// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IMergeNFT} from "./interfaces/IMergeNFT.sol";


/// @title MergeNFT Storage 
/// @author matheus
abstract contract MergeNFTStorage {

  /// @notice Keeps track of the amount of tokens merged
  uint256 public totalMerged;

  /// @notice Storage configuration for collection
  IMergeNFT.Configuration public config;

  /// @notice Storage configuration for the merge mint flow
  IMergeNFT.MergeConfiguration public mergeConfig;

  /// @notice Keeps track of the merged tokens
  mapping(uint256 tokenId => bool merged) public tokensMerged;

  /// @notice Keeps track of number of tokens an address merged
  mapping(address user => uint256 total) public totalMergedByUser;
}