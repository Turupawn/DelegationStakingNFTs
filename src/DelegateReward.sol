// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface IDiva is IERC20{
    function delegate(address delegatee) external;
}

contract DelegateReward {

    IDiva public diva;
    address public delegatee;

    constructor(address divaAddress, address _delegatee) {
        diva = IDiva(divaAddress);
        delegatee = _delegatee;
        diva.delegate(delegatee);
    }

    function delegateAndClaim(uint amount) public {
        diva.transferFrom(msg.sender, address(this), amount);
        diva.delegate(delegatee);
    }
}
