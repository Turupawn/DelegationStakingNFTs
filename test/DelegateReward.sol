// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DelegateReward.sol";
import "../src/FactoryDelegateReward.sol";
import "../src/HoldersReward.sol";

contract CounterTest is Test {

    IGovernanceToken public governanceToken;
    DelegateReward public delegateReward;
    HoldersReward public holdersReward;

    //// Diva params on Mainnet ////
    /*
    // Diva token
    address tokenAddress = 0xBFAbdE619ed5C4311811cF422562709710DB587d;
    // Diva whale
    address delegator = 0x777E2B2Cc7980A6bAC92910B95269895EEf0d2E8;
    */

    //// OP params on Optimism ////
    // OP token
    address tokenAddress = 0x4200000000000000000000000000000000000042;
    // OP whale
    address delegator = 0xb4FCc24173E21E99E6C5485608c6aDFb73Bc35C7;
    /*
    */

    function setUp() public {
        governanceToken = IGovernanceToken(
            tokenAddress);
        FactoryDelegateReward factoryDelegateReward = new FactoryDelegateReward();
        factoryDelegateReward.createDelegateReward(0xb6F5414bAb8d5ad8F33E37591C02f7284E974FcB);
        delegateReward = DelegateReward(factoryDelegateReward.getDelegateRewardAddress(0xb6F5414bAb8d5ad8F33E37591C02f7284E974FcB));

        holdersReward = new HoldersReward(address(delegateReward), address(tokenAddress), 100 days);
    }

    function testDelegate() public {
        vm.prank(delegator);
        governanceToken.approve(address(delegateReward), 10 ether);
        vm.prank(delegator);
        delegateReward.delegateAndMint(
            10 ether,
            address(governanceToken));
        skip(100 days);
        holdersReward.claim(0);
        vm.prank(delegator);
        delegateReward.undelegateAndBurn(0);
    }
}
