// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MarketPlace {
    ERC20 public stablecoin;
    ERC20 public assetToken;
    AggregatorV3Interface public priceFeed;

    constructor(address _stablecoin, address _assetToken, address _priceFeed) {
        stablecoin = ERC20(_stablecoin);
        assetToken = ERC20(_assetToken);
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getLatestPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function buyAssetToken(uint256 stablecoinAmount) public {
        int rawPrice = getLatestPrice();
        require(rawPrice > 0, "Invalid price data");

        uint256 adjustedPrice = uint256(rawPrice) / 1e8; // Adjust for price feed decimals
        uint256 assetTokenAmount = (stablecoinAmount * 1e18) / adjustedPrice;

        require(stablecoin.transferFrom(msg.sender, address(this), stablecoinAmount), "Transfer failed");
        require(assetToken.transfer(msg.sender, assetTokenAmount), "Transfer failed");
    }

}
