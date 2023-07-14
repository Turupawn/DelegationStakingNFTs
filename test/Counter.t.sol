// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DelegateReward.sol";

contract CounterTest is Test {

    IDiva public diva;
    DelegateReward public delegateReward;

    function setUp() public {
        diva = IDiva(
            0xBFAbdE619ed5C4311811cF422562709710DB587d);
        delegateReward = new DelegateReward(address(diva),
            0xb6F5414bAb8d5ad8F33E37591C02f7284E974FcB);
    }

    function testSupply() public {

        vm.prank(0x777E2B2Cc7980A6bAC92910B95269895EEf0d2E8);
        diva.approve(address(delegateReward), 10 ether);
        vm.prank(0x777E2B2Cc7980A6bAC92910B95269895EEf0d2E8);
        delegateReward.delegateAndClaim(10 ether);
        //diva.transfer(address(0), 12 ether);
    }
}
