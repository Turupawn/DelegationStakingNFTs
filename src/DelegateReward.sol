// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "openzeppelin-contracts/token/ERC721/ERC721.sol";

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

contract DelegateReward is ERC721 {
    struct Stake {
        uint amount;
        uint deadline;
    }

    IDiva public diva;
    address public DELEGATEE;
    uint public STAKE_TIME;
    uint public nftCount;
    mapping(uint nftId => Stake) public stakes;


    constructor(address divaAddress, address delegatee, uint stakeTime)
        ERC721("Diva Delegator Token", "DDT")
    {
        diva = IDiva(divaAddress);
        DELEGATEE = delegatee;
        diva.delegate(DELEGATEE);
        STAKE_TIME = stakeTime;
    }

    function delegateAndMint(uint amount) public {
        diva.transferFrom(msg.sender, address(this), amount);

        _mint(msg.sender, nftCount);
        stakes[nftCount] = Stake(amount, block.timestamp + STAKE_TIME);
        nftCount += 1;
    }

    function undelegateAndBurn(uint nftId) public {
        require(msg.sender == ownerOf(nftId), "Must be nft owner");
        require(block.timestamp >= stakes[nftId].deadline, "Staking period not over");
        _burn(nftId);
        //TODO: currently blocked by Diva
        //diva.transfer(msg.sender, stakes[nftId].amount);
    }
}
