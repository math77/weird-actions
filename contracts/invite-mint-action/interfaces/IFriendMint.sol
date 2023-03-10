// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

/// @author matheus
interface IFriendMint {

  /// @notice Only admin can access the function
  error AccessOnlyAdmin();
  
  /// @notice Only invitees can mint and invite new one
  error NotInvited();

  /// @notice Storage of invitation information
  struct Invitation {
    uint256 invitedDate;
    address invitedBy;
  }
  
}