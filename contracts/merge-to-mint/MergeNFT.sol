// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

//import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

import {ERC721AUpgradeable} from "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


import {MergeNFTStorage} from "./MergeNFTStorage.sol";

import {IMergeNFT} from "./interfaces/IMergeNFT.sol";

import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";


/// @title MergeNFT 
/// @author matheus
contract MergeNFT is IMergeNFT, MergeNFTStorage, ERC721AUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable, AccessControlUpgradeable {

  /// @notice Access control roles
  bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
  bytes32 public immutable MERGE_MANAGER_ROLE = keccak256("MERGE_MANAGER");

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
  
  /// @dev Initialize a new merge contract
  /// @param _mergeNFTName The merge collection name
  /// @param _mergeNFTSymbol The merge collection symbol
  /// @param _maxSupply Collection max supply
  /// @param _initialOwner The owner of contract
  /// @param _fundsRecipient Address that receives funds from mint
  /// @param _renderer Address for the renderer contract
  /// @param _collectionToMerge Collection where the NFTs to merge live
  function initialize(
    string memory _mergeNFTName,
    string memory _mergeNFTSymbol,
    uint64 _maxSupply,
    address _initialOwner,
    address payable _fundsRecipient,
    IMetadataRenderer _renderer,
    IERC721 _collectionToMerge
  ) public initializer {
    __ERC721A_init(_mergeNFTName, _mergeNFTSymbol);
    __AccessControl_init();
    __ReentrancyGuard_init();

    _grantRole(DEFAULT_ADMIN_ROLE, _initialOwner);

    config.maxSupply = _maxSupply;
    config.collectionToMerge = _collectionToMerge;
    config.metadataRenderer = _renderer;
    config.fundsRecipient = _fundsRecipient;
  }

  /// @notice Merge n NFTs to receive an new owner
  /// @param tokens List of tokenIds owned by msg.sender to merge 
  function merge(uint256[] calldata tokens) 
    external 
    payable 
    hasSupplyLeft(1)
    returns (uint256) 
  {

    /*
      
      TODO: What's the best merge-mint flow?

      First, the users transfer the tokens they want to merge to 
      the contract and the contract registers a "pass" with this. 

      Then these users access the mint function to merge their 
      sent tokens and get the new token

      ?????????? 

      exists an better flow?????

    */

    /*
      For NFTs that have been merged to be burned, the collection 
      used to merge must have a public or external burn function
    */
  }

  /// @notice Verify if who (msg.sender) whos all the NFTs in tokens array
  /// @dev If any token is not owned by who the execution is reverted
  /// @param who Address from msg.sender
  /// @param tokens List of tokenIds sent by msg.sender to verify ownership
  function verifyTokensOwnership(address who, uint256[] calldata tokens) public view {

    for(uint256 i; i < tokens.length;) {
      if(IERC721(config.collectionToMerge).ownerOf(tokens[i]) != who) {
        revert NotTokenOwner();
      }

      unchecked{i++;}
    }
  }

  /// @notice Merge all tokens in tokens array
  /// @param tokens List of tokenIds sent by msg.sender to verify ownership
  function mergeTokens(uint256[] calldata tokens) internal {
    for(uint256 i; i < tokens.length;) {
      tokensMerged[tokens[i]] = true;

      unchecked{i++;}
    }
  }

  /// @notice Verify if any token in the array have already been merged
  /// @param tokens List of tokenIds sent by msg.sender to verify merge status
  function verifyTokensAlreadyMerged(uint256[] calldata tokens) public view {
    for(uint256 i; i < tokens.length;) {
      if(tokensMerged[tokens[i]]) revert TokenAlreadyMerged();

      unchecked{i++;}
    }
  }

  function setMergeConfiguration(
    uint104 mergePrice,
    uint32 amountToMergePerMint,
    uint32 maxMergePerAddress,
    uint64 mergeStart,
    uint64 mergeEnd
  ) external onlyRoleOrAdmin(MERGE_MANAGER_ROLE) {
    mergeConfig.mergePrice = mergePrice;
    mergeConfig.amountToMergePerMint = amountToMergePerMint;
    mergeConfig.maxMergePerAddress = maxMergePerAddress;
    mergeConfig.mergeStart = mergeStart;
    mergeConfig.mergeEnd = mergeEnd;

    emit MergeConfigChanged({changedBy: _msgSender()});
  }

  function mergeDetails() external view returns (IMergeNFT.MergeDetails memory) {
    return
      IMergeNFT.MergeDetails({
        mergePrice: mergeConfig.mergePrice,
        totalMinted: _totalMinted(),
        totalMerged: totalMerged,
        maxSupply: config.maxSupply,
        mergeStart: mergeConfig.mergeStart,
        mergeEnd: mergeConfig.mergeEnd,
        amountToMergePerMint: mergeConfig.amountToMergePerMint,
        maxMergePerAddress: mergeConfig.maxMergePerAddress
      });
  }

  /// @return boolean is address is admin
  function isAdmin(address user) external view returns (bool) {
    return hasRole(DEFAULT_ADMIN_ROLE, user);
  }

  function statsPerAddress(address minter) external view returns (IMergeNFT.AddressMinterDetails memory) {
    return
      IMergeNFT.AddressMinterDetails({
        totalMints: _numberMinted(minter),
        totalMerged: totalMergedByUser[minter]
      });
  }

  function setMetadataRenderer(IMetadataRenderer newRenderer) external onlyAdmin {
    config.metadataRenderer = newRenderer;

    emit UpdatedMetadataRenderer({
      updater: _msgSender(),
      renderer: newRenderer
    });
  }

  function setCollectionToMerge(IERC721 newCollectionToMerge) external onlyAdmin {

    config.collectionToMerge = newCollectionToMerge;

    emit UpdatedCollectionToMerge({
      updater: _msgSender(),
      toMerge: newCollectionToMerge
    });

  }

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
      type(IMergeNFT).interfaceId == interfaceId;
  }
}