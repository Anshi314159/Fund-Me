// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


error FundMe__NotOwner();

contract FundMe{
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] /*public*/ private s_funders;
    mapping (address funder => uint256 amountFunded) /*public*/ private s_addressToAmountFunded;

    address /*public*/ private immutable i_owner;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent
        require(msg.value.getConversionRate(s_priceFeed)>=MINIMUM_USD, "didn't send enough ETH"); // 1e18 = 1 ETH = 10**18 wei
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value;
    }

    
    function withdraw() public onlyOwner {  
        uint256 funderLength = s_funders.length;
        // for loop is used for looping through the list/array of addresses
        for (uint256 index = 0; index < funderLength; index++){
            address funder = s_funders[index];
            s_addressToAmountFunded[funder] = 0;
        } 

        // reset the array
        s_funders = new address[](0);   // this creates a brand new array
        // actually withdraw the funds

        // transfer
        // payable (msg.sender).transfer(address(this).balance);
        //send
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require(sendSuccess,"Failed");
        //call
        (bool callSuccess, ) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner,"Must be owner");
        if (msg.sender != i_owner){
            revert FundMe__NotOwner();
        }
        _;
    }

    function getVersion() public view returns(uint256){
        //AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return s_priceFeed.version();
    }

    receive() external payable {
        fund();
    }
    fallback() external payable { 
        fund();
    }

    function getFunders(uint256 index) public view returns (address){
        return s_funders[index];
    }

    function getAddressToAmountFunded(address _funder) public view returns (uint256){
        return s_addressToAmountFunded[_funder];        
    }

    function getOwner() public view returns(address) {
        return i_owner;
    }

}