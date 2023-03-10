// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {IFriendMint} from "./interfaces/IFriendMint.sol";

/// @title FriendMint Storage 
/// @author matheus
abstract contract FriendMintStorage {

  /// @notice TokenId of NFT minted
  uint256 public tokenId;

  /// @notice Collection max supply
  uint256 public maxSupply;

  /// @notice Keeps track of the invitations
  mapping(address invited => IFriendMint.Invitation invitation) public invitations;
}