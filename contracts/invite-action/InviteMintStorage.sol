// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {IInviteMint} from "./interfaces/IInviteMint.sol";

/// @title InviteMintStorage 
/// @author matheus
abstract contract InviteMintStorage {

  /// @notice Storage configuration for NFT mint
  IInviteMint.Configuration public config;

  // @notice Mint configuration
  IInviteMint.MintConfiguration public mintConfig;

  /// @notice Keeps track of the invitations
  mapping(address invited => IInviteMint.Invitation invitation) public invitations;

  /// @notice Keeps track of amount of invitations an address has
  mapping(address invited => uint256 invites) public amountOfInvites;
}