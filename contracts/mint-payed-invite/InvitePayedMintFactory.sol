// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {InvitePayedMintProxy} from "./InvitePayedMintProxy.sol";

import {IInvitePayedMintFactory} from "./interfaces/IInvitePayedMintFactory.sol";
import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";

import {InvitePayedMint} from "./InvitePayedMint.sol";


/// @title InvitePayedMint Factory 
/// @author matheus
contract InvitePayedMintFactory is IInvitePayedMintFactory, OwnableUpgradeable, UUPSUpgradeable {

  /// @notice Address for implementation of InviteMint to clone
  address public immutable implementation;
  
  
  /// @notice Initializes factory with address of implementation contract
  /// @param _implementation InviteMint implementation contract to clone
  constructor(address _implementation) initializer {
    if(_implementation == address(0)) revert AddressCannotBeZero();

    implementation = _implementation;
  }

  /// @notice Initializes the proxy contract
  function initialize() external initializer {
    __Ownable_init();
    __UUPSUpgradeable_init();
  }

  /// @dev Function to determine who is allowed to upgrade this contract.
  function _authorizeUpgrade(address _newImplementation) internal override onlyOwner {}


  /// @notice Create a new InviteMint
  /// @param inviteMintName The invitemint collection name
  /// @param inviteMintSymbol The invitemint collection symbol
  /// @param maxSupply Collection max supply
  /// @param initialOwner The owner of contract
  /// @param fundsRecipient Address tha receive funds from mint
  /// @param renderer Address for the metadata contract 
  function createNewInviteMint(
    string memory inviteMintName,
    string memory inviteMintSymbol,
    uint64 maxSupply,
    address initialOwner,
    address payable fundsRecipient,
    IMetadataRenderer renderer
  ) public payable returns (address newInviteMintAddress) {
    InvitePayedMintProxy newInviteMint = new InvitePayedMintProxy(implementation, "");

    newInviteMintAddress = address(newInviteMint);
    InvitePayedMint(newInviteMintAddress).initialize({
      _inviteMintName: inviteMintName,
      _inviteMintSymbol: inviteMintSymbol,
      _maxSupply: maxSupply,
      _initialOwner: initialOwner,
      _fundsRecipient: fundsRecipient,
      _renderer: renderer
    });

    emit InvitePayedMintCreated({
      inviteMint: newInviteMintAddress,
      owner: initialOwner
    });

  }

}