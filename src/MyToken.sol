// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IStudentToken} from "./IStudentToken.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./helper/ISwapRouter.sol";
import "./helper/TransferHelper.sol";

contract MyToken is IStudentToken, ERC20 { 
    address public RewardToken = 0x56822085cf7C15219f6dC404Ba24749f08f34173;
    address public EvaluatorToken = 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE;
    uint24 public poolFee = 1000; // 0.1%

    ISwapRouter public immutable swapRouter;

    constructor(uint256 initialSupply, ISwapRouter _swapRouter) ERC20("SachaToken", "SAT") {
        _mint(msg.sender, initialSupply);
        _mint(address(this), 50000000);
        _approve(address(this), 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE, 30000000); // Allow to solve ex2 we need 10000000 tokens approved for the transferFrom
        _mint(0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE, 30000000); // Allow to solve ex3 (it should be 20000000 if I solved ex2 with the same contract)
        swapRouter = _swapRouter;
    }

    function createLiquidityPool() external override {
       
    }

    function SwapRewardToken(
        uint256 _amountOut,
        uint256 _amountInMaximum
    ) external returns (uint256 amountIn) {
        IERC20(EvaluatorToken).transferFrom(
            msg.sender,
            address(this),
            amountIn
        );
        IERC20(EvaluatorToken).approve(address(swapRouter), amountIn);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: EvaluatorToken,
                tokenOut: RewardToken,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: _amountOut,
                amountInMaximum: _amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < _amountInMaximum) {
            IERC20(EvaluatorToken).approve(address(swapRouter), 0);

            IERC20(EvaluatorToken).transfer(
                msg.sender,
                _amountInMaximum - amountIn
            );
        }

        return amountIn;
    }
}