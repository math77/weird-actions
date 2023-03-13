// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {InviteMintProxy} from "./InviteMintProxy.sol";

import {IInviteMintFactory} from "./interfaces/IInviteMintFactory.sol";

import {InviteMint} from "./InviteMint.sol";


/// @title InviteMint Factory 
/// @author matheus
contract InviteMintFactory is IInviteMintFactory, OwnableUpgradeable, UUPSUpgradeable {

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
  /// @param maxTokensByMint Max number of tokens an address can mint by invite
  /// @param maxInvitesByAddress Max number of invites an same address can receive
  /// @param initialOwner The owner of contract
  /// @param renderer Address for the metadata contract 
  function createNewInviteMint(
    string memory inviteMintName,
    string memory inviteMintSymbol,
    uint256 maxSupply,
    uint256 maxTokensByMint,
    uint256 maxInvitesByAddress,
    address initialOwner,
    address renderer
  ) public payable returns (address newInviteMintAddress) {
    InviteMintProxy newInviteMint = new InviteMintProxy(implementation, "");

    newInviteMintAddress = address(newInviteMint);
    InviteMint(newInviteMintAddress).initialize({
      _inviteMintName: inviteMintName,
      _inviteMintSymbol: inviteMintSymbol,
      _maxSupply: maxSupply,
      _maxTokensByMint: maxTokensByMint,
      _maxInvitesByAddress: maxInvitesByAddress,
      _initialOwner: initialOwner,
      _renderer: renderer
    });

    emit InviteMintCreated({
      inviteMint: newInviteMintAddress,
      owner: initialOwner
    });

  }

}