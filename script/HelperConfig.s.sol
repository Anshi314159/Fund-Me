//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
    // If we are on a local bloackchain like anvil, we deploy mocks
    // otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor(){
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if (block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        }
        else if (block.chainid == 1337){
            activeNetworkConfig = getOrCreateGanacheEthConfig();
        }
        else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    } 

    function getMainnetEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory ethConfig = NetworkConfig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory){

        if (activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }

        //1. Deploy the mock
        //2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL,INITIAL_ANSWER);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed:address(mockPriceFeed)});
        return anvilConfig;

    }
    function getOrCreateGanacheEthConfig() public returns (NetworkConfig memory){

        if (activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }

        //1. Deploy the mock
        //2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL,INITIAL_ANSWER);
        vm.stopBroadcast();

        NetworkConfig memory ganacheConfig = NetworkConfig({priceFeed:address(mockPriceFeed)});
        return ganacheConfig;

    }

}