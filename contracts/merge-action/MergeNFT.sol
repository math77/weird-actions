// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


import {MergeNFTStorage} from "./MergeNFTStorage.sol";

import {IMergeNFT} from "./interfaces/IMergeNFT.sol";


/// @title MergeNFT 
/// @author matheus
contract MergeNFT is IMergeNFT, MergeNFTStorage, ERC721Upgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable, AccessControlUpgradeable {

  modifier onlyAdmin() { 
    if(!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
      revert AccessOnlyAdmin();
    }
    _; 
  }
  
  /// @dev Initialize a new merge contract
  /// @param _mergeNFTName The merge collection name
  /// @param _mergeNFTSymbol The merge collection symbol
  /// @param _amountToMerge Number of tokens required to merge in order to mint new one
  /// @param _initialOwner The owner of contract (msg.sender who called the function in the factory contract)
  /// @param _renderer Address for the metadata contract
  /// @param _collectionToMerge Collection where the NFTs to merge live
  function initialize(
    string memory _mergeNFTName,
    string memory _mergeNFTSymbol,
    uint256 _amountToMerge,
    address _initialOwner,
    address _renderer,
    IERC721 _collectionToMerge
  ) public initializer {
    __ERC721_init(_mergeNFTName, _mergeNFTSymbol);
    __AccessControl_init();
    __ReentrancyGuard_init();

    _grantRole(DEFAULT_ADMIN_ROLE, _initialOwner);
    //_setOwner(_initialOwner);

    collectionToMerge = _collectionToMerge;
    amountToMerge = _amountToMerge;
  }

  /// @notice Merge n NFTs to receive an new owner
  /// @param tokens List of tokenIds owned by msg.sender to merge 
  function mergeNFTs(
    uint256[] calldata tokens
  ) external payable {

    if(tokens.length != amountToMerge) revert WrongNumberOfTokens();

    verifyTokensOwnership(_msgSender(), tokens);

    verifyTokensAlreadyMerged(tokens);

    mergeTokens(tokens);

    /*
      For NFTs that have been merged to be burned, the collection 
      used to merge must have a public or external burn function
    */

    // mint new token to msg.sender
    unchecked {
      _mint(_msgSender(), ++tokenId);
    }

  
    emit TokensMerged({
      newTokenId: tokenId
    });
  }

  /// @notice Verify if who (msg.sender) whos all the NFTs in tokens array
  /// @dev If any token is not owned by who the execution is reverted
  /// @param who Address from msg.sender
  /// @param tokens List of tokenIds sent by msg.sender to verify ownership
  function verifyTokensOwnership(address who, uint256[] calldata tokens) public view {

    for(uint256 i; i < tokens.length;) {
      if(IERC721(collectionToMerge).ownerOf(tokens[i]) != who) {
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

  /// @notice Burn tokenId
  /// @param tokenId Token ID to burn
  function burn(uint256 tokenId) public {
    _burn(tokenId, true);
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    return "";
  }


  function _authorizeUpgrade(address _newImplementation) internal override onlyAdmin {}

  function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, AccessControlUpgradeable) returns (bool) {
    return 
      super.supportsInterface(interfaceId) ||
      type(IMergeNFT).interfaceId == interfaceId;
  }
}