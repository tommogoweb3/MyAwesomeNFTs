// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol"; // Allows to do console logs
import { Base64 } from "./libraries/Base64.sol"; // import helper function

contract MyAwesomeNFTs is ERC721URIStorage {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; //state variable
    
    string baseSvg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string baseSvg2 = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string[] firstWords = ["Shitty", "Tasty", "Blue", "Warm", "Spooky", "Magnificent", "Lazy", "German", "High", "Drunk"];
    string[] secondWords = ["Castle", "Basketball", "Coding", "Generative", "Hat", "Action", "Dream", "Flat", "Minivan", "Turbo"];
    string[] thirdWords = ["Kakukk", "Poop", "Warrior", "NFT", "Magic", "Woof", "Popi", "Rizsi", "Pizza", "Music"];
    string[] colors = ["black", "blue", "red", "green", "yellow", "#08C2A8"];
    uint256 MaxSupply = 50;

    //devnotes

    event NewAwesomeNFTMinted(address sender, uint256 tokenId);


    // pass the name of NFTs and Symbol
    constructor() ERC721 ("3 Awesome Words", "3AWEW") {
        console.log("This is my NFT Contract. Pretty cool!");
        _tokenIds.increment(); // set first mint to #1
        console.log("First mint # successfully set to 1");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))); // seed random generator
        rand = rand % firstWords.length; // squash the # between 0 and the length of the array to avoid going out of bounds
        return firstWords[rand];
    }
    function pickRandomSecondWord(uint256 tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))); // seed random generator
        rand = rand % secondWords.length; // squash the # between 0 and the length of the array to avoid going out of bounds
        return secondWords[rand];
    }
    function pickRandomThirdWord(uint256 tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))); // seed random generator
        rand = rand % thirdWords.length; // squash the # between 0 and the length of the array to avoid going out of bounds
        return thirdWords[rand];
    }
    function pickRandomColor(uint256 tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId)))); // seed random generator
        rand = rand % colors.length; // squash the # between 0 and the length of the array to avoid going out of bounds
        return colors[rand];
    }
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }


    // function for minting NFTs BTW THIS IS NOT PAYABLE YET
    function makeAnAwesomeNFT() public {
        uint256 newItemId = _tokenIds.current(); // get the current tokenId, starting at 0
        require(newItemId < MaxSupply, "Sorry, we are sold out!");
        
        // Randomly grab one word from each of the three arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        string memory randomColor = pickRandomColor(newItemId);

        // concatenate it all together, then close the <text> and <svg> tags
        string memory finalSvg = string(abi.encodePacked(baseSvg1, randomColor, baseSvg2, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // set the title of the NFT as the generated word
                        combinedWord,
                        '", "description": "A highly acclaimed collection of simple words.", "image": "data:image/svg+xml;base64,',
                        // add data: image/svg+xml;base64 and then append our base64 encode svg
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // prepend data:application/json;base64, to our data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n----------------");
        console.log(finalTokenUri);
        console.log("----------------\n");


        _safeMint(msg.sender, newItemId); // mint the NFT to the sender LOOK UP THE ORIGIN
        _setTokenURI(newItemId, finalTokenUri); // set the NFTs data
        console.log("An NFT with ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment(); // increment the counter for when the next NFT is minted

        emit NewAwesomeNFTMinted(msg.sender, newItemId);
    }

    function mintedSoFar() public view returns (uint256) {
        uint256 mintCount = _tokenIds.current() - 1;
        return mintCount;
    }
}

