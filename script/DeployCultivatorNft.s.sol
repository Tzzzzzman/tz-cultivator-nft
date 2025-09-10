// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {CultivatorNft} from "../src/CultivatorNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title This is used to deploy Cultivator NFT.
 * @author Tzzzzzman
 */
contract DeployCultivatorNft is Script {
    function run() external returns (CultivatorNft) {
        string memory happySvg = vm.readFile("./img/happy.svg");
        vm.startBroadcast();
        CultivatorNft cultivatorNft = new CultivatorNft(happySvg);
        vm.stopBroadcast();
        return cultivatorNft;
    }

    function svgToImageUri(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
