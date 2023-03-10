// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {IInviteMint} from "./interfaces/IInviteMint.sol";

/// @title InviteMint Storage 
/// @author matheus
abstract contract InviteMintStorage {

  /// @notice TokenId of NFT minted
  uint256 public tokenId;

  /// @notice Collection max supply
  uint256 public maxSupply;

  /// @notice Keeps track of the invitations
  mapping(address invited => IInviteMint.Invitation invitation) public invitations;
}