// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC721AUpgradeable} from "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import {IERC721AUpgradeable} from "erc721a-upgradeable/contracts/IERC721AUpgradeable.sol";

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

  /// @notice Access control roles
  bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
  bytes32 public immutable MINT_MANAGER_ROLE = keccak256("MINT_MANAGER");


  /// @notice Only users with admin role can access
  modifier onlyAdmin() { 
    if(!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
      revert AccessOnlyAdmin();
    }
    _; 
  }

  /// @notice Only users with admin or role can access
  /// @param role Role to check for alongside with admin role
  modifier onlyRoleOrAdmin(bytes32 role) {
    if(
      !hasRole(DEFAULT_ADMIN_ROLE, _msgSender()) &&
      !hasRole(role, _msgSender())
    ) {
      revert AccessOnlyRoleOrAdmin(role);
    }

    _; 
  }

  /// @notice Checks if the desired quantity to mint not exceed the supply
  /// @param quantity Number of tokens desired to mint
  modifier hasSupplyLeft(uint256 quantity) {
    if(quantity + _totalMinted() > config.maxSupply) {
      revert SupplySoldOut();
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
  function mint(uint256 quantity, address inviting) 
    external  
    payable 
    nonReentrant
    hasSupplyLeft(quantity)
    returns (uint256) 
  {

    if(invitations[_msgSender()].invitedDate == 0) revert NotInvited();

    uint256 mintPrice = mintConfig.mintPrice;

    if(msg.value != (mintPrice * quantity)) revert WrongPrice({correctPrice: mintPrice * quantity});

    if(amountOfInvites[inviting] == mintConfig.maxInvitesPerAddress) revert MaxInvitationsReached();

    if(inviting == _msgSender()) revert CannotInviteYourself();
    if(inviting == address(0)) revert InvitingCannotBeZero();

    invitations[inviting] = IInviteMint.Invitation({
      invitedDate: block.timestamp,
      invitedBy: _msgSender()
    });

    amountOfInvites[inviting] += 1;

    delete invitations[_msgSender()];

    _mintNFTs(_msgSender(), quantity);
    uint256 firstMintedTokenId = _lastMintedTokenId() - quantity;

    emit IInviteMint.Mint({
      to: _msgSender(),
      invited: inviting,
      quantity: quantity,
      pricePerToken: mintPrice,
      firstMintedTokenId: firstMintedTokenId
    });

    return firstMintedTokenId;
  }

  /// @return boolean is address is admin
  function isAdmin(address user) external view returns (bool) {
    return hasRole(DEFAULT_ADMIN_ROLE, user);
  }

  function statsPerAddress(address minter) external view override returns (IInviteMint.AddressMinterDetails memory) {
    return 
      IInviteMint.AddressMinterDetails({
        totalMints: _numberMinted(minter),
        totalInvitations: amountOfInvites[minter]
      });
  }

  //to implement this 5 functions below
  function mintDetails() external view returns (IInviteMint.MintDetails memory) {
    return 
      IInviteMint.MintDetails({
        mintPrice: mintConfig.mintPrice,
        totalMinted: _totalMinted(),
        maxSupply: config.maxSupply,
        mintStart: mintConfig.mintStart,
        mintEnd: mintConfig.mintEnd,
        maxTokensPerAddress: mintConfig.maxTokensPerAddress,
        maxInvitesPerAddress: mintConfig.maxInvitesPerAddress
      });
  }

  function setMetadataRenderer(IMetadataRenderer newRenderer) external onlyAdmin {
    config.metadataRenderer = newRenderer;

    emit UpdatedMetadataRenderer({
      updater: _msgSender(),
      renderer: newRenderer
    });
  }

  //TODO: test if is more efficient use uint256 rather of uint64

  /// @notice Function to set mint start date (when the contract owner minted the first token)
  function _setMintStartDate() internal {
    mintConfig.mintStart = uint64(block.timestamp);
  }

  /// @notice Function to set mint end date (when the last token was minted)
  function _setMintEndDate() internal {
    mintConfig.mintEnd = uint64(block.timestamp);
  }


  /// @notice Mint admin. Start the flow by mint token #1 and invite the next minter
  function adminMint(uint256 quantity, address inviting) 
    external 
    onlyRoleOrAdmin(MINTER_ROLE)
    hasSupplyLeft(quantity)
    returns (uint256)
  {

    if(mintConfig.mintStart != 0) revert AdminAlreadyMinted();
    if(inviting == _msgSender()) revert CannotInviteYourself();
    if(inviting == address(0)) revert InvitingCannotBeZero();

    invitations[inviting] = IInviteMint.Invitation({
      invitedDate: block.timestamp,
      invitedBy: _msgSender()
    });

    _mintNFTs(_msgSender(), quantity);

    _setMintStartDate();

    return _lastMintedTokenId();
  }

  /// @notice Function to mint quantity tokens to address to
  /// @dev This batches in size of 8 as per recommended by ERC721A creators
  /// @param to Address to mint the tokens for
  /// @param quantity Number of tokens to mint
  function _mintNFTs(address to, uint256 quantity) internal {
    do {
      uint256 toMint = quantity > MAX_MINT_BATCH_SIZE ? MAX_MINT_BATCH_SIZE : quantity;
      _mint({to: to, quantity: toMint});
      quantity -= toMint;
    } while (quantity > 0); 
  }


  /// @notice Function to configure mint
  /// @param mintPrice Price per token in eth
  /// @param maxTokensPerAddress Number max of tokens an address can mint
  /// @param maxInvitesPerAddress Number max of invites an address can receive
  function setMintConfiguration(
    uint104 mintPrice,
    uint32 maxTokensPerAddress,
    uint32 maxInvitesPerAddress
  ) external onlyRoleOrAdmin(MINT_MANAGER_ROLE) {
    mintConfig.mintPrice = mintPrice;
    mintConfig.maxTokensPerAddress = maxTokensPerAddress;
    mintConfig.maxInvitesPerAddress = maxInvitesPerAddress;

    emit MintConfigChanged({changedBy: _msgSender()});
  }

  /// @notice Burn tokenId
  /// @param tokenId Token ID to burn
  function burn(uint256 tokenId) public {
    _burn(tokenId, true);
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {

    if(!_exists(tokenId)) {
      revert IERC721AUpgradeable.URIQueryForNonexistentToken();
    }

    return config.metadataRenderer.tokenURI(tokenId);
  }


  function _authorizeUpgrade(address _newImplementation) internal override onlyAdmin {}

  function supportsInterface(bytes4 interfaceId) public view override(ERC721AUpgradeable, AccessControlUpgradeable) returns (bool) {
    return 
      super.supportsInterface(interfaceId) ||
      type(IInviteMint).interfaceId == interfaceId;
  }
}