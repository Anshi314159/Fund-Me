// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice(AggregatorV3Interface dataFeed) internal view returns(uint256){
        // address (from docs.chain.link) 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // abi we use interface
        //AggregatorV3Interface dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); 
        (, int256 answer, , , ) = dataFeed.latestRoundData();
        // price of eth in terms of usd  2000.00000000  (8 decimal zeros) and eth to wie(18 decimal zeroes)
        return uint256(answer*1e10);

    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface dataFeed) internal view returns(uint256){
        // 1 Eth = $2000_0000000000
        uint256 ethPrice = getPrice(dataFeed);  // $2000_000000000000000000
        // (2000000000000000000000 * 3000000000000000000)/1e18 = 6000_1e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; 
        return ethAmountInUsd;
    }
}   