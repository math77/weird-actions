// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

//import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {ERC721AUpgradeable} from "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


import {InviteMintStorage} from "./InviteMintStorage.sol";

import {IInviteMint} from "./interfaces/IInviteMint.sol";
import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";


/// @title InviteMint 
/// @author matheus
contract InviteMint is IInviteMint, InviteMintStorage, ERC721AUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable, AccessControlUpgradeable {

  /// @dev This is the max mint batch size for the optimized ERC721A mint contract
  uint256 internal immutable MAX_MINT_BATCH_SIZE = 8;

  modifier onlyAdmin() { 
    if(!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
      revert AccessOnlyAdmin();
    }
    _; 
  }

  /// @notice Return the last minted tokenId 
  function _lastMintedTokenId() internal view returns (uint256) {
    return _nextTokenId() - 1;
  }

  /// @notice Starting the tokenId at 1 rather than 0
  function _startTokenId() internal pure override returns (uint256) {
    return 1;
  }

  
  /// @dev Initialize a new invitemint contract
  /// @param _inviteMintName The invitemint collection name
  /// @param _inviteMintSymbol The invitemint collection symbol
  /// @param _maxSupply Collection max supply
  /// @param _initialOwner The owner of contract
  /// @param _fundsRecipient Address that receives funds from mint
  /// @param _renderer Address for the metadata contract
  function initialize(
    string memory _inviteMintName,
    string memory _inviteMintSymbol,
    uint64 _maxSupply,
    address _initialOwner,
    address payable _fundsRecipient,
    IMetadataRenderer _renderer
  ) public initializer {
    __ERC721A_init(_inviteMintName, _inviteMintSymbol);
    __AccessControl_init();
    __ReentrancyGuard_init();

    _grantRole(DEFAULT_ADMIN_ROLE, _initialOwner);

    config.maxSupply = _maxSupply;
    config.fundsRecipient = _fundsRecipient;
    config.metadataRenderer = _renderer;
  }

  /// @notice Mint quantity NFT and invite someone else to be the next minter
  /// @param quantity Number of tokens to mint
  /// @param inviting Who the current minter is inviting to mint the next one
  function mint(uint256 quantity, address inviting) external override payable returns (uint256) {
    _mint(_msgSender(), quantity);
  }

  function statsPerAddress(address minter) external view override returns (IInviteMint.AddressMinterDetails memory) {
    return 
      IInviteMint.AddressMinterDetails({
        totalMints: _numberMinted(minter),
        totalInvitations: amountOfInvites[minter]
      });
  }

  //to implement this 5 functions below
  function mintDetails() external view returns (MintDetails memory) {}

  function setMetadataRenderer(IMetadataRenderer newRenderer) external {}

  function setMintStartDate(uint64 startDate) external {}

  function setMintEndDate(uint64 endDate) external {}

  function setMintConfiguration(
    uint104 mintPrice,
    uint32 maxTokensPerAddress,
    uint32 maxInvitesPerAddress
  ) external {}

  /// @notice Burn tokenId
  /// @param tokenId Token ID to burn
  function burn(uint256 tokenId) public {
    _burn(tokenId, true);
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    return "";
  }


  function _authorizeUpgrade(address _newImplementation) internal override onlyAdmin {}

  function supportsInterface(bytes4 interfaceId) public view override(ERC721AUpgradeable, AccessControlUpgradeable) returns (bool) {
    return 
      super.supportsInterface(interfaceId) ||
      type(IInviteMint).interfaceId == interfaceId;
  }
}