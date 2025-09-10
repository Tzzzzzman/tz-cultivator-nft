// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {CultivatorNft} from "../src/CultivatorNft.sol";
import {DeployCultivatorNft} from "../script/DeployCultivatorNft.s.sol";

/**
 * @title This is used to test Cultivator NFT.
 * @author Tzzzzzman
 */
contract CultivatorNftTest is Test {
    DeployCultivatorNft public deployer;
    CultivatorNft public cultivatorNft;
    address public USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployCultivatorNft();
        cultivatorNft = deployer.run();
    }

    function testCreate() public {
        vm.prank(USER);
        cultivatorNft.create();
        console.log("Token URI :", cultivatorNft.tokenURI(0));
        assertEq(cultivatorNft.balanceOf(USER), 1);
    }
}
