// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {MergeNFTProxy} from "./MergeNFTProxy.sol";

import {IMergeNFTFactory} from "./interfaces/IMergeNFTFactory.sol";

import {MergeNFT} from "./MergeNFT.sol";


/// @title MergeNFT Factory 
/// @author matheus
contract MergeFactory is IMergeNFTFactory, OwnableUpgradeable, UUPSUpgradeable {

  /// @notice Address for implementation of MergeNFT to clone
  address public immutable implementation;
  
  
  /// @notice Initializes factory with address of implementation contract
  /// @param _implementation MergeNFT implementation contract to clone
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


  /// @notice Create a new MergeNFT
  /// @param mergeNFTName The name of the new contract (cannot be changed later)
  /// @param mergeNFTSymbol The symbol of the new contract (cannot be changed later)
  /// @param amountToMerge The amount of required tokens to merge in order to mint a new one
  /// @param initialOwner The owner of contract
  /// @param renderer Address for the metadata contract
  /// @param collectionToMerge Collection where the NFTs to merge live 
  function createNewMergeNFT(
    string memory mergeNFTName,
    string memory mergeNFTSymbol,
    uint256 amountToMerge,
    address initialOwner,
    address renderer,
    IERC721 collectionToMerge
  ) public payable returns (address newMergeNFTAddress) {
    MergeNFTProxy newMergeNFT = new MergeNFTProxy(implementation, "");

    newMergeNFTAddress = address(newMergeNFT);
    MergeNFT(newMergeNFTAddress).initialize({
      _mergeNFTName: mergeNFTName,
      _mergeNFTSymbol: mergeNFTSymbol,
      _amountToMerge: amountToMerge,
      _initialOwner: initialOwner,
      _renderer: renderer,
      _collectionToMerge: collectionToMerge
    });

    emit MergeNFTCreated({
      mergeNFT: newMergeNFTAddress,
      owner: initialOwner
    });

  }

}