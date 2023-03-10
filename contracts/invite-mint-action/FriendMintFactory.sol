// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {FriendMintProxy} from "./FriendMintProxy.sol";

import {IFriendMintFactory} from "./interfaces/IFriendMintFactory.sol";

import {FriendMint} from "./FriendMint.sol";


/// @title FriendMint Factory 
/// @author matheus
contract FriendMintFactory is IFriendMintFactory, OwnableUpgradeable, UUPSUpgradeable {

  /// @notice Address for implementation of FriendMint to clone
  address public immutable implementation;
  
  
  /// @notice Initializes factory with address of implementation contract
  /// @param _implementation FriendMint implementation contract to clone
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


  /// @notice Create a new FriendMint
  /// @param friendMintName The friendmint collection name
  /// @param friendMintSymbol The friendmint collection symbol
  /// @param maxSupply Collection max supply
  /// @param initialOwner The owner of contract
  /// @param renderer Address for the metadata contract 
  function createNewFriendMint(
    string memory friendMintName,
    string memory friendMintSymbol,
    uint256 maxSupply,
    address initialOwner,
    address renderer
  ) public payable returns (address newFriendMintAddress) {
    FriendMintProxy newFriendMint = new FriendMintProxy(implementation, "");

    newFriendMintAddress = address(newFriendMint);
    FriendMint(newFriendMintAddress).initialize({
      _friendMintName: friendMintName,
      _friendMintSymbol: friendMintSymbol,
      _maxSupply: maxSupply,
      _initialOwner: initialOwner,
      _renderer: renderer
    });

    emit FriendMintCreated({
      friendMint: newFriendMintAddress,
      owner: initialOwner
    });

  }

}