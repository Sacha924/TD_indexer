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

    function getLatestPrice(uint256 _amount) public view returns (uint256) {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData();
        return (_amount*uint(answer))/(10**8);
    }

    function swap(uint256 _amount) public{
        require(stablecoin.allowance(msg.sender, address(this)) >= uint(_amount), "stablecoin Allowance too low");

        uint256 latestPrice = getLatestPrice(_amount);
        uint256 adjustedPrice = latestPrice * 1e18;

        require(assetToken.balanceOf(address(this)) >= uint(adjustedPrice), "Not enough balance in the contract");
        stablecoin.transferFrom(msg.sender, address(this), _amount*10**18);
        assetToken.transfer(msg.sender, adjustedPrice);
    }

}
