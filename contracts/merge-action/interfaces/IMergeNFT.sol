// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

/// @author matheus
interface IMergeNFT {

  /// @notice Only admin can access the function
  error AccessOnlyAdmin();
  
  /// @notice Only the NFTs owner can merge
  error NotTokenOwner();

  /// @notice Only not merged tokens can be merged
  error TokenAlreadyMerged();

  /// @notice When the number of tokens sent by msg.sender is different from the number set by the creator
  error WrongNumberOfTokens();

  /// @notice Emits when NFTs have been merged
  event TokensMerged(uint256 newTokenId);

  /// @notice Verify if who owns all the tokens in tokens array
  /// @param who Address of the msg.sender
  /// @param tokens Tokens ids sent by msg.sender
  function verifyTokensOwnership(address who, uint256[] calldata tokens) external view;

  /// @notice Verify if any token in the array have already been merged
  /// @param tokens Tokens ids sent by msg.sender
  function verifyTokensAlreadyMerged(uint256[] calldata tokens) external view;
}