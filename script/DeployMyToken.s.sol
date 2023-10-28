// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Evaluator} from "../src/EvaluatorToken.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeploymentScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyToken myToken = new MyToken(1000000000 *(10**18));

        vm.stopBroadcast();
    }
}