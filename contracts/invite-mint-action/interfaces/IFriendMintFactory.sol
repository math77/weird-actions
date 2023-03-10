// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

/// @author matheus
interface IFriendMintFactory {

  /// @notice Only address different from address(0) is accepted
  error AddressCannotBeZero();

  /// @notice Emit when a new FriendMint contract is created
  event FriendMintCreated(address friendMint, address owner);

  /// @notice Emit when a new metadata renderer contract address is added
  event NewMetadataRendererAdded(address renderer); 
}