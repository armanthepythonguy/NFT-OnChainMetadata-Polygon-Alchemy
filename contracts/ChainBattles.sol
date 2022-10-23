// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage{
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct TokenStats {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    mapping(uint256 => TokenStats) public tokenIdToLevels;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function getLevels(uint256 _tokenId) public view returns(string memory){
        uint256 levels = tokenIdToLevels[_tokenId].level;
        return levels.toString();
    }

    function getSpeed(uint256 _tokenId) public view returns(string memory){
        uint256 speed = tokenIdToLevels[_tokenId].speed;
        return speed.toString();
    }

    function getLife(uint256 _tokenId) public view returns(string memory){
        uint256 life = tokenIdToLevels[_tokenId].life;
        return life.toString();
    }

    function getStrength(uint256 _tokenId) public view returns(string memory){
        uint256 strength = tokenIdToLevels[_tokenId].strength;
        return strength.toString();
    }

    function generateCharacter(uint256 _tokenId) public view returns(string memory){
        bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(_tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(_tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(_tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(_tokenId),'</text>',
        '</svg>'
        );
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function getTokenURI(uint256 _tokenId) public view returns(string memory){
        bytes memory dataURI = abi.encodePacked(
            '{','"name":"Chain Battles #',_tokenId.toString(),'",','"description": "Battles on chain",','"image":"', generateCharacter(_tokenId),'"','}'
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }

    function mint() public{
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId].level = getRandomNumber();
        tokenIdToLevels[newItemId].life = getRandomNumber();
        tokenIdToLevels[newItemId].strength = getRandomNumber();
        tokenIdToLevels[newItemId].speed = getRandomNumber();
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function getRandomNumber() public view returns(uint256){
        return(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%3);
    }

    function train(uint256 _tokenId) public{
        require(_exists(_tokenId), "Please use an existing token");
        require(ownerOf(_tokenId)==msg.sender, "You must own this token to train it!!");
        tokenIdToLevels[_tokenId].level++;
        tokenIdToLevels[_tokenId].life++;
        tokenIdToLevels[_tokenId].strength++;
        tokenIdToLevels[_tokenId].speed++;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));
    }
}