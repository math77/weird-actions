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

  /// @notice Emitted when mint configuration has been changed
  /// @param changedBy who changed the config
  event MintConfigChanged(address indexed changedBy);

  /// @notice Emitted when metadata renderer is updated.
  /// @param updater who updated
  /// @param renderer new metadata renderer address
  event UpdatedMetadataRenderer(address updater, IMetadataRenderer renderer);

  /// @notice Event emitted for each successfully mint
  /// @param to address mint was made to
  /// @param invited who the minter invited to be the next minter
  /// @param quantity amount of tokens minted
  /// @param pricePerToken price for each token
  /// @param firstMintedTokenId the first token id minted
  event Mint(
    address indexed to,
    address invited,
    uint256 indexed quantity,
    uint256 indexed pricePerToken,
    uint256 firstMintedTokenId
  );

  /// @notice Storage of invitation information
  struct Invitation {
    // date minter was invited
    uint256 invitedDate;
    // who invited the minter
    address invitedBy;
  }

  /// @notice Collection basic configuration
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
    uint104 mintPrice;
    // max number of tokens an address can mint by invite
    uint32 maxTokensPerAddress;
    // max number of invites an same address can receive
    uint32 maxInvitesPerAddress;
    // date mint started (when the contract owner minted the first token)
    uint64 mintStart;
    // date mint ended (when the last token was minted)
    uint64 mintEnd;
  }

  /// @notice Return infos about mint details
  struct MintDetails {
    // mint price per token in eth
    uint256 mintPrice;
    // total minted so far
    uint256 totalMinted;
    // max supply available
    uint256 maxSupply;
    // when mint started
    uint64 mintStart;
    // when mint ended
    uint64 mintEnd;
    // max number of tokens an address can mint by invite
    uint32 maxTokensPerAddress;
    // max number of invites an same address can receive
    uint32 maxInvitesPerAddress;
  }

  /// @notice Return stats details per specific address
  struct AddressMinterDetails {
    // how many tokens minted
    uint256 totalMints;
    // how many invites received
    uint256 totalInvitations;
  }

  /// @notice Admin function to update the mint configuration settings
  /// @param mintPrice mint price per token in eth
  /// @param maxTokensPerAddress Max tokens a address can mint
  /// @param maxInvitesPerAddress Max invites a address can receive
  function setMintConfiguration(
    uint104 mintPrice,
    uint32 maxTokensPerAddress,
    uint32 maxInvitesPerAddress
  ) external;

  /// @notice Update the metadata renderer
  /// @param newRenderer New renderer address
  function setMetadataRenderer(IMetadataRenderer newRenderer) external;

  /// @notice Function to set mint start date (when the contract owner minted the first token)
  /// @param startDate the start date (unix timestamp)
  function setMintStartDate(uint64 startDate) external;

  /// @notice Function to set mint start date (when the last token was minted)
  /// @param endDate the end date (unix timestamp)
  function setMintEndDate(uint64 endDate) external;

  /// @notice External mint function (payable in ETH)
  /// @param quantity Amount of tokens to min
  /// @param inviting Address invited to be the next minter
  /// @return first minted token id
  function mint(uint256 quantity, address inviting) external payable returns(uint256);

  /// @notice Function to return the global mint details for the collection
  function mintDetails() external view returns (MintDetails memory);

  /// @notice Return the mint stats for a specific given address 
  /// @param minter The address for return specific stats
  /// @return the stats associated with the minter
  function statsPerAddress(address minter) external view returns(AddressMinterDetails memory);
  
}