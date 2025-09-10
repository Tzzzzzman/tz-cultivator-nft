// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Cultivator NFT
 * @author Tzzzzzman
 */
contract CultivatorNft is ERC721 {
    using Strings for uint256;

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
        // require(msg.value > 0.01 ether, "You need to spend 0.01 ETH.");
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
                            cultivator.health.toString(),
                            ', "attack": ',
                            cultivator.attack.toString(),
                            ', "defense": ',
                            cultivator.defense.toString(),
                            ', "life": ',
                            cultivator.life.toString(),
                            ', "wealth": ',
                            cultivator.wealth.toString(),
                            '}], "image":"',
                            s_defaultImg,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /**
     * Trigger a random event.
     *
     * TODO: Change the trigger method to Chainlink Automation.
     */
    function randomEvent() public view {
        uint256[] memory happendedEventCultivators = new uint256[](cultivators.length);
        for (uint256 i; i < cultivators.length; i++) {
            if (happendedEventCultivators[i] == 1) {
                continue;
            }
            Cultivator memory cultivator = cultivators[i];
            uint256 randomEventUint = generateRandomUintNum(0, 99);
            if (randomEventUint < 5) {
                discoverWealth(cultivator);
            } else if (randomEventUint < 20) {
                discoverTheFountainOfLife(cultivator);
            } else if (randomEventUint < 30) {
                sometingGoodHappened(cultivator);
            } else if (randomEventUint < 40) {
                sometingBadHappened(cultivator);
            } else {
                uint256 opponentIndex = findOpponentIndex(i, happendedEventCultivators);
                happendedEventCultivators[opponentIndex] = 1;
                Cultivator memory opponent = cultivators[opponentIndex];
                fightingBetweenTwoCultivators(cultivator, opponent);
            }
        }
    }

    /////////////////////
    // getter fuctions
    /////////////////////

    function getTokenIdToCultivator(uint256 tokenId) public view returns (Cultivator memory) {
        return s_tokenIdToCultivator[tokenId];
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
     * TODO: Change the generate method to Chainlink VRF.
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
        cultivator.life = 100;
        cultivator.wealth = 100;
        cultivator.attack = generateRandomUintNum(5, 10);
        cultivator.defense = generateRandomUintNum(1, 5);
        cultivator.health = generateRandomUintNum(50, 100);
        cultivator.wuxing = WuXing(generateRandomUintNum(0, 4));
        cultivators.push(cultivator);
    }

    function findOpponentIndex(uint256 nowIndex, uint256[] memory happendedEventCultivators)
        private
        view
        returns (uint256 opponentIndex)
    {
        opponentIndex = generateRandomUintNum(nowIndex + 1, happendedEventCultivators.length);
        while (happendedEventCultivators[opponentIndex] == 1) {
            opponentIndex = generateRandomUintNum(nowIndex + 1, happendedEventCultivators.length);
        }
    }

    function fightingBetweenTwoCultivators(Cultivator memory cultivator1, Cultivator memory cultivator2) private pure {
        uint256 cultivator1Damage = cultivator2.attack - cultivator1.defense;
        uint256 cultivator2Damage = cultivator1.attack - cultivator2.defense;
        if (cultivator1Damage > 0) {
            cultivator1.health -= cultivator1Damage;
        }
        if (cultivator2Damage > 0) {
            cultivator2.health -= cultivator2Damage;
        }
    }

    function sometingBadHappened(Cultivator memory cultivator) private view {
        uint256 decreaseType = generateRandomUintNum(0, 1);
        if (decreaseType == 0) {
            cultivator.attack -= 1;
        } else {
            cultivator.defense -= 1;
        }
    }

    function sometingGoodHappened(Cultivator memory cultivator) private view {
        uint256 decreaseType = generateRandomUintNum(0, 1);
        if (decreaseType == 0) {
            cultivator.attack += 1;
        } else {
            cultivator.defense += 1;
        }
    }

    function discoverTheFountainOfLife(Cultivator memory cultivator) private pure {
        cultivator.health += 5;
    }

    function discoverWealth(Cultivator memory cultivator) private pure {
        cultivator.wealth += 10;
    }
}
