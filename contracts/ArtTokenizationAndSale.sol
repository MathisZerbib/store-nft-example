// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // Import Strings library

contract ArtTokenizationAndSale is ERC1155, Ownable {
    using SafeMath for uint256;
    using Strings for uint256; // Use Strings library for uint256 conversion

    // Mapping from token ID to supply
    mapping(uint256 => uint256) private _tokenSupply;

    // Mapping from token ID to creator
    mapping(uint256 => address) private _tokenCreators;

    // Events
    event TokenMinted(address indexed creator, uint256 indexed id, uint256 amount);
    event BatchTransfer(address indexed from, address indexed to, uint256[] ids, uint256[] amounts);
    event BatchApproval(address indexed owner, address indexed approved, uint256[] ids);
    event TokensReceived(address operator, address from, uint256 id, uint256 value, bytes data);

    // New base URI structure
    string private _baseTokenURI;

    // Constructor
    constructor(string memory baseTokenURI, address initialOwner) ERC1155(baseTokenURI) Ownable(initialOwner) {
        _baseTokenURI = baseTokenURI;
    }

    // Mint new tokens
    function mint(address account, uint256 id, uint256 amount) external onlyOwner {
        _mint(account, id, amount, "");
        _tokenSupply[id] = _tokenSupply[id].add(amount);
        _tokenCreators[id] = msg.sender;
        emit TokenMinted(msg.sender, id, amount);
    }

// Create a 3x3 grid of NFTs from a single one
function createGrid(uint256 baseTokenId) external {
    // Ensure the base token exists
    require(_tokenSupply[baseTokenId] > 0, "Base token does not exist");

    // Mint the 3x3 grid of NFTs
    for (uint256 i = 0; i < 3; i++) {
        for (uint256 j = 0; j < 3; j++) {
            // Calculate the new token ID for each piece in the grid
            uint256 newTokenId = baseTokenId * 100 + i * 30 + j * 3 + 1;

            // Mint the new token
            _mint(msg.sender, newTokenId, 1, "");

            // Set the token supply to 1
            _tokenSupply[newTokenId] = 1;

            // Set the creator of the new token to be the same as the base token
            _tokenCreators[newTokenId] = _tokenCreators[baseTokenId];

            // Emit the TokenMinted event
            emit TokenMinted(_tokenCreators[baseTokenId], newTokenId, 1);
            // update the metadatas 
            _setTokenURI(newTokenId, string(abi.encodePacked(_baseTokenURI, newTokenId.toString())));
            
        }
    }
}


    // Batch transfer tokens
    function batchTransfer(address from, address to, uint256[] calldata ids, uint256[] calldata amounts) external {
        require(from == msg.sender || isApprovedForAll(from, msg.sender), "Not approved");
        _safeBatchTransferFrom(from, to, ids, amounts, "");
        emit BatchTransfer(from, to, ids, amounts);
    }

    // Batch approval of all tokens to an address
    function batchApproval(address owner, address approved, uint256[] calldata ids) external onlyOwner {
        _setApprovalForAll(owner, approved, true);
        emit BatchApproval(owner, approved, ids);
    }

    // Hooks: Receive tokens
    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes calldata data) external returns (bytes4) {
        emit TokensReceived(operator, from, id, value, data);
        return this.onERC1155Received.selector;
    }

    // Set Base URI
    function setBaseURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    // Update Token URI
    function updateTokenURI(uint256 tokenId, string calldata newTokenURI) external onlyOwner {
        require(_tokenCreators[tokenId] == msg.sender, "Not the creator");
        emit TokensReceived(msg.sender, address(0), tokenId, 0, "");
        _baseTokenURI = newTokenURI;
    }

    // Get Token URI
    function tokenURI() public view returns (string memory) {
        return bytes(_baseTokenURI).length > 0 ? string(abi.encodePacked(_baseTokenURI)) : "";
    }
}
