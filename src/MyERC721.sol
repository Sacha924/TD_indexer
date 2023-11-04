// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IStudentNft} from "./IStudentNft.sol";
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MyERC721 is IStudentNft, ERC721 { 

    IERC20 public collateralToken; // The ERC20 token used as collateral.
    uint256 public collateralRequirement = 1 * (10 ** 18);

    constructor() ERC721("MyERC721Sachaaa", "MSC") {
        collateralToken = IERC20(0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE);
        setApprovalForAll(0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE, true);
        _mint(0x1F65257306ea309aef96391691e4189fD8102EBc, 2);
        _mint(0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE, 10);
    }

    function mint(uint256 tokenIdToMint) external override {
        require(collateralToken.allowance(msg.sender, address(this)) >= collateralRequirement, "cannot mint nft without collateral");         // Check if the sender has given enough allowance to the contract
        require(collateralToken.transferFrom(msg.sender, address(this), collateralRequirement), "Token transfer failed");

        _mint(msg.sender, tokenIdToMint);
    }

    function mintWithoutCollat(uint256 tokenIdToMint) external {
        _mint(msg.sender, tokenIdToMint);
    }

    function burn(uint256 tokenIdToBurn) external override {
        _burn(tokenIdToBurn);
    }
}
