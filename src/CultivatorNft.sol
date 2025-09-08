// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Cultivator NFT
 * @author Tzzzzzman
 */
contract CultivatorNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_defaultImg;
    mapping(uint256 => Cultivator) private s_tokenIdToCultivator;
    Cultivator[] private cultivators;

    enum WuXing {
        JIN,
        MU,
        SHUI,
        HUO,
        TU
    }

    struct Cultivator {
        bool initialied;
        string name;
        uint256 attack;
        uint256 defense;
        uint256 health;
        uint256 life;
        uint256 wealth;
        WuXing wuxing;
    }

    constructor(string memory imageUrl) ERC721("Cultivator NFT", "CN") {
        s_defaultImg = imageUrl;
        s_tokenCounter = 0;
    }

    /////////////////////
    // public fuctions
    /////////////////////

    function create() public payable {
        require(msg.value > 0.01 ether, "You need to spend 0.01 ETH.");
        _safeMint(msg.sender, s_tokenCounter);
        createCultivator(s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        Cultivator memory cultivator = s_tokenIdToCultivator[tokenId];
        require(cultivator.initialied, "Your cultivator has not yet bean generated.");
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"An cultivator that you create!", ',
                            '"attributes": [{"health": ',
                            cultivator.health,
                            ', "attack": ',
                            cultivator.attack,
                            ', "defense": ',
                            cultivator.defense,
                            ', "life": ',
                            cultivator.life,
                            ', "wealth": ',
                            cultivator.wealth,
                            ', "wuxing": ',
                            cultivator.wuxing,
                            '}], "image":"',
                            s_defaultImg,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /////////////////////
    // internal fuctions
    /////////////////////

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /////////////////////
    // private fuctions
    /////////////////////

    /**
     * Generate random uint num for Cultivator's attributes.
     *
     * @param min The minimum value of the random number
     * @param max The maximum value of the random number
     */
    function generateRandomUintNum(uint256 min, uint256 max) private view returns (uint256) {
        uint256 randomNum =
            uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, blockhash(block.number - 1))));
        uint256 range = max - min + 1;
        return min + (randomNum % range);
    }

    /**
     * Create a cultivator and put it in map.
     *
     * @param tokenId tokenId
     */
    function createCultivator(uint256 tokenId) private {
        Cultivator storage cultivator = s_tokenIdToCultivator[tokenId];
        cultivator.initialied = true;
        cultivator.attack = generateRandomUintNum(5, 10);
        cultivator.defense = generateRandomUintNum(1, 5);
        cultivator.health = generateRandomUintNum(50, 100);
        cultivator.wuxing = WuXing(generateRandomUintNum(0, 4));
        cultivators.push(cultivator);
    }
}
