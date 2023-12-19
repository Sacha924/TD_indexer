// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {AssetToken} from "./../src/AssetToken.sol";
import {StableCoin} from "./../src/StableCoin.sol";
import {MarketPlace} from "./../src/MarketPlace.sol";

contract DeploymentScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        AssetToken ass = new AssetToken(100000 * (10**18));
        StableCoin sta = new StableCoin(500 * (10**18));
        new MarketPlace(address(ass), address(sta), 0x48731cF7e84dc94C5f84577882c14Be11a5B7456); // Link - usd

        vm.stopBroadcast();
    }
}
