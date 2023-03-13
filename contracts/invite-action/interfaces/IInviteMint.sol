// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

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

  /// @notice Storage of invitation information
  struct Invitation {
    uint256 invitedDate;
    address invitedBy;
  }
  
}