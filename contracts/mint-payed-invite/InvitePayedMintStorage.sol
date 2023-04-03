// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {IInvitePayedMint} from "./interfaces/IInvitePayedMint.sol";

/// @title InviteMintStorage 
/// @author matheus
abstract contract InvitePayedMintStorage {

  /// @notice Storage configuration for NFT mint
  IInvitePayedMint.Configuration public config;

  // @notice Mint configuration
  IInvitePayedMint.MintConfiguration public mintConfig;

  /// @notice Keeps track of the invitations
  mapping(address invited => IInvitePayedMint.Invitation invitation) public invitations;

  /// @notice Keeps track of amount of invitations an address has
  mapping(address invited => uint256 invites) public amountOfInvites;
}