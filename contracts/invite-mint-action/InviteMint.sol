// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


import {InviteMintStorage} from "./InviteMintStorage.sol";

import {IInviteMint} from "./interfaces/IInviteMint.sol";


/// @title InviteMint 
/// @author matheus
contract InviteMint is IInviteMint, InviteMintStorage, ERC721Upgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable, AccessControlUpgradeable {

  modifier onlyAdmin() { 
    if(!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
      revert AccessOnlyAdmin();
    }
    _; 
  }
  
  /// @dev Initialize a new invitemint contract
  /// @param _inviteMintName The invitemint collection name
  /// @param _inviteMintSymbol The invitemint collection symbol
  /// @param _maxSupply Collection max supply
  /// @param _maxTokensByMint Max number of tokens an address can mint by invite
  /// @param _maxInvitesByAddress Max number of invites an same address can receive
  /// @param _initialOwner The owner of contract
  /// @param _renderer Address for the metadata contract
  function initialize(
    string memory _inviteMintName,
    string memory _inviteMintSymbol,
    uint256 _maxSupply,
    uint256 _maxTokensByMint,
    uint256 _maxInvitesByAddress,
    address _initialOwner,
    address _renderer
  ) public initializer {
    __ERC721_init(_inviteMintName, _inviteMintSymbol);
    __AccessControl_init();
    __ReentrancyGuard_init();

    _grantRole(DEFAULT_ADMIN_ROLE, _initialOwner);
    //_setOwner(_initialOwner);

    maxSupply = _maxSupply;
    maxTokensByMint = _maxTokensByMint;
    maxInvitesByAddress = _maxInvitesByAddress;
  }

  /// @notice Mint 1 NFT and invite someone else to mint the next one
  /// @param inviting Who the current minter is inviting to mint the next one
  function mint(address inviting) external payable {}

  /// @notice Burn tokenId
  /// @param tokenId Token ID to burn
  function burn(uint256 tokenId) public {
    _burn(tokenId);
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    return "";
  }


  function _authorizeUpgrade(address _newImplementation) internal override onlyAdmin {}

  function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, AccessControlUpgradeable) returns (bool) {
    return 
      super.supportsInterface(interfaceId) ||
      type(IInviteMint).interfaceId == interfaceId;
  }
}