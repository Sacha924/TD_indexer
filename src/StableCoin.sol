// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StableCoin is ERC20 {
    constructor(uint256 initialSupply) ERC20("Stablecoin", "STBL") {
        _mint(msg.sender, initialSupply/2);
        _mint(address(this), initialSupply/2);
    }

    function receiveToken(uint256 _amount) public {
        _mint(msg.sender, _amount*10**18);
    }
}