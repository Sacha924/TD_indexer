// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IStudentToken} from "./IStudentToken.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract MyToken is IStudentToken, ERC20 { 
    constructor(uint256 initialSupply) ERC20("SachaToken", "SAT") {
        _mint(msg.sender, initialSupply);
        _mint(address(this), 50000000);
        _approve(address(this), 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE, 30000000); // Allow to solve ex2 we need 10000000 tokens approved for the transferFrom
        _mint(0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE, 30000000); // Allow to solve ex3 (it should be 20000000 if I solved ex2 with the same contract)
    }

    function createLiquidityPool() external override {
       
    }

    function SwapRewardToken() external override {
        
    }
}