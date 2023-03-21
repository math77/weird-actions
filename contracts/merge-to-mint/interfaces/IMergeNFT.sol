// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

/*
 Some of the decisions in this file are inspired by the zora-drops repository:
 https://github.com/ourzora/zora-drops-contracts
*/


import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IMetadataRenderer} from "./IMetadataRenderer.sol";


/// @author matheus
interface IMergeNFT {

  /// @notice Only admin can access the function
  error AccessOnlyAdmin();

  /// @notice Only role or admin can access the function
  error AccessOnlyRoleOrAdmin(bytes32 role);

  /// @notice Only address different from address(0) is accepted
  error AddressCannotBeZero();
  
  /// @notice Only the tokens owner can merge
  error NotTokenOwner();

  /// @notice The tokens max supply was reached
  error SupplySoldOut();

  /// @notice Only not merged tokens can be merged
  error TokenAlreadyMerged();

  /// @notice When the number of tokens sent is different from the number set by the creator
  error WrongNumberOfTokens(uint256 correctNumber);

  /// @notice Wrong price for mint the tokens
  error WrongPrice(uint256 correctPrice);

  /// @notice Emits when tokens have been merged
  /// @param to Address that receives the new token minted
  /// @param amountMerged how many tokens get merged
  /// @param tokenId ID of new token minted
  event Merge(
    address indexed to,
    uint256 indexed amountMerged,
    uint256 tokenId
  );

  /// @notice Emitted when merge configuration has been changed
  /// @param changedBy who changed the config
  event MergeConfigChanged(address indexed changedBy);

  /// @notice Emitted when metadata renderer is updated.
  /// @param updater who updated
  /// @param renderer new metadata renderer address
  event UpdatedMetadataRenderer(address updater, IMetadataRenderer renderer);

  /// @notice Emitted when the collection to merge tokens is updated.
  /// @param updater who updated
  /// @param toMerge new collection to merge address
  event UpdatedCollectionToMerge(address updater, IERC721 toMerge);

  /// @notice Collection basic configuration
  struct Configuration {
    // metadata renderer
    IMetadataRenderer metadataRenderer;
    /// @notice Address of the origin collection of tokens to merge
    IERC721 collectionToMerge;
    // collection max supply
    uint64 maxSupply;
    // address who receives funds from mint
    address payable fundsRecipient;
  }

  /// @notice Mint state and configuration
  struct MergeConfiguration {
    // price per merge
    uint104 mergePrice;
    // amount of tokens to merge
    uint32 amountToMergePerMint;
    // max number of merges an same address can do
    uint32 maxMergePerAddress;
    // date mint started
    uint64 mergeStart;
    // date mint ended
    uint64 mergeEnd;
  }

  /// @notice Return infos about mint details
  struct MergeDetails {
    // merge price per token in eth
    uint256 mergePrice;
    // total minted so far
    uint256 totalMinted;
    // total merged so far
    uint256 totalMerged;
    // max supply available
    uint64 maxSupply;
    // when mint started
    uint64 mergeStart;
    // when mint ended
    uint64 mergeEnd;
    // number of tokens an address need to merge to mint new token
    uint32 amountToMergePerMint;
    // max number of merges an same address can do
    uint32 maxMergePerAddress;
  }

  /// @notice Return stats details per specific address
  struct AddressMinterDetails {
    // how many tokens minted
    uint256 totalMints;
    // how many tokens merged
    uint256 totalMerged;
  }

  /// @notice Admin function to update the mint configuration settings
  /// @param mergePrice Merge price per token in eth
  /// @param amountToMergePerMint Amount of tokens an address need to merge to mint new token  
  /// @param maxMergePerAddress Max merge an address can do
  function setMergeConfiguration(
    uint104 mergePrice,
    uint32 amountToMergePerMint,
    uint32 maxMergePerAddress,
    uint64 mergeStart,
    uint64 mergeEnd
  ) external;

  /// @notice External merge function (payable in ETH)
  /// @param tokens List of tokens to merge in order to get new one
  /// @return new minted token id
  function merge(uint256[] calldata tokens) external payable returns (uint256);

  /// @notice Return the mint stats for a specific given address 
  /// @param minter The address for return specific stats
  /// @return the stats associated with the minter
  function statsPerAddress(address minter) external view returns (AddressMinterDetails memory);

  /// @notice Function to return the global mint details for the collection
  function mergeDetails() external view returns (MergeDetails memory);
  
  /// @notice Verify if who owns all the tokens in tokens array
  /// @param who Address of the msg.sender
  /// @param tokens Tokens sent by msg.sender
  function verifyTokensOwnership(address who, uint256[] calldata tokens) external view;

  /// @notice Verify if any token in the array have already been merged
  /// @param tokens Tokens sent by msg.sender
  function verifyTokensAlreadyMerged(uint256[] calldata tokens) external view;

  /// @notice Update the metadata renderer
  /// @param newRenderer New renderer address
  function setMetadataRenderer(IMetadataRenderer newRenderer) external;

  /// @notice Update the collection to merge
  /// @param newCollectionToMerge New collection address
  function setCollectionToMerge(IERC721 newCollectionToMerge) external;

  /// @dev Getter for admin role
  /// @param user Address to check if is admin
  /// @return boolean if address is admin
  function isAdmin(address user) external view returns (bool);
}