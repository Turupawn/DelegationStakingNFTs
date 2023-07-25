// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./DelegateReward.sol";

contract FactoryDelegateReward {
    mapping(address delegatee => address delegateRewardAddress) public delegateRewardAddresses;

    function getDelegateRewardAddress(address delegatee) public view returns(address) {
        return delegateRewardAddresses[delegatee];
    }

    function createDelegateReward(address delegatee) public {
        delegateRewardAddresses[delegatee] = address(new DelegateReward(delegatee));
    }
}