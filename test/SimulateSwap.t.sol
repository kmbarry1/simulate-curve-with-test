// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "./TokenMock.sol";

interface CurveFactory {
    function deploy_plain_pool(string calldata, string calldata, address[4] calldata, uint256, uint256, uint256, uint256) external returns (address);
}

interface CurvePool {
    function add_liquidity(uint256[2] calldata, uint256, address) external returns (uint256);
    function exchange(int128, int128, uint256, uint256, address) external returns (uint256);
}

contract SimulateSwapTest is Test {
    TokenMock token0;
    TokenMock token1;
    CurveFactory constant factory = CurveFactory(address(0xB9fC157394Af804a3578134A6585C0dc9cc990d4));
    CurvePool pool;

    function setUp() public {
        token0 = new TokenMock(10**27);  // start w/1 billion of each token minted to the test contract
        token1 = new TokenMock(10**27);
        address[4] memory tokenAddrs;
        tokenAddrs[0] = address(token0);
        tokenAddrs[1] = address(token1);
        string memory name   = "test_pool";
        string memory symbol = "XYZ";
        pool = CurvePool(factory.deploy_plain_pool(
            name,
            symbol,
            tokenAddrs,
            100,      // A
            4000000,  // fee
            0,        // asset type (0 = USD)
            3         // implementation_idx; 3 = optimized for ERC20s w/18 decimals that return true/revert
        ));
        token0.approve(address(pool), type(uint256).max);
        token1.approve(address(pool), type(uint256).max);
    }

    function test_swap() public {
        uint256[2] memory amounts;
        amounts[0] = 100 * 10**18;
        amounts[1] = 100 * 10**18;
        pool.add_liquidity(amounts, /* _min_mint_amount */ 0, /* _receiver */ address(this));

        uint256 amtToSwap = 10 * 10**18;

        // exchange swapAmount of token0 for token1
        uint256 amtReceived = pool.exchange(0, 1, amtToSwap, /* _min_dy */ 0, /* _receiver */ address(this));
        console2.log("amtToSwap:",   amtToSwap);
        console2.log("amtReceived:", amtReceived);
    }
}
