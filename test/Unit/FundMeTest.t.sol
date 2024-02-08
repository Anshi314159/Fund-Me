// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    
    function setUp() external {
        // us(msg.sender) -> FundMeTest -> FundMe  
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUSDIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        // assertEq(fundMe.i_owner(), address(this));
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedIsAccurate() public {
        assertEq (fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundupdatesFundedDataStructure() public {
        vm.prank(USER);  // The next tx will be sent by USER
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountfunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountfunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunders(0);
        assertEq(funder, USER);
    }

    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded{
        // vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 EndingOwnerBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        assertEq(EndingFundMeBalance, 0);
        assertEq(EndingOwnerBalance, startingFundMeBalance + startingOwnerBalance);
        
        }
    
    function testWithdrawWithMultipleFunder() public {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
            // vm.prank new address
            // vm.deal (address, balance)
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value:SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //Assert
        uint256 EndingOwnerBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        assertEq(EndingFundMeBalance, 0);
        assertEq(EndingOwnerBalance, startingFundMeBalance + startingOwnerBalance);
    }
    

}