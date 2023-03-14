// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

/*
 Some of the decisions in this file are inspired by the zora-drops repository:
 https://github.com/ourzora/zora-drops-contracts
*/

import {IMetadataRenderer} from "./IMetadataRenderer.sol";

/// @author matheus
interface IInviteMint {

  /// @notice Only admin can access the function
  error AccessOnlyAdmin();
  
  /// @notice Only invitees can mint and invite new one
  error NotInvited();

  /// @notice Not allowed invite yourself (address) to mint
  error CannotInviteYourself();

  /// @notice The address reached the max number of invitations allowed
  error MaxInvitationsReached();

  /// @notice The quantity to mint exceed the max number allowed
  error MaxTokensByMintExceed();

  /// @notice The tokens max supply was reached
  error SupplySoldOut();

  /// @notice Wrong price for mint the tokens
  error WrongPrice(uint256 correctPrice);

  /// @notice Storage of invitation information
  struct Invitation {
    // date minter was invited
    uint256 invitedDate;
    // who invited the minter
    address invitedBy;
  }

  struct Configuration {
    // metadata renderer
    IMetadataRenderer metadataRenderer;
    // collection max supply
    uint64 maxSupply;
    // address who receives funds from mint
    address payable fundsRecipient;

  }

  /// @notice Mint state and configuration
  struct MintConfiguration {
    // price by token
    uint104 publicMintPrice;
    // max number of tokens an address can mint by invite
    uint32 maxTokensPerAddress;
    // max number of invites an same address can receive
    uint32 maxInvitesPerAddress;
    // date mint started (when the contract owner minted the first token)
    uint64 publicMintStarted;
    // date mint ended (when the last token was minted)
    uint64 publicMintEnded;
  }

  /// @notice Return stats details per specific address
  struct AddressMinterDetails {
    uint256 totalMints;
    uint256 totalInvitations;
  }

  /// @notice External mint function (payable in ETH)
  /// @param quantity Amount of tokens to min
  /// @param inviting Address invited to be the next minter
  /// @return first minted token id
  function mint(uint256 quantity, address inviting) external payable returns(uint256);

  /// @notice Return the mint stats for a specific given address 
  /// @param minter The address for return specific stats
  /// @return the stats associated with the minter
  function statsPerAddress(address minter) external view returns(AddressMinterDetails memory);
  
}