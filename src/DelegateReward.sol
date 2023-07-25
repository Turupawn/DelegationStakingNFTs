// SPDX-License-Identifier: MIT
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

interface IGovernanceToken is IERC20{
    function delegate(address delegatee) external;
}

contract DelegateReward is ERC721 {
    struct Stake {
        uint amount;
        uint startTimestamp;
        address tokenAddress;
    }

    IGovernanceToken public diva;
    uint public nftCount;
    mapping(uint nftId => Stake) public stakes;
    address DELEGATEE;

    constructor(address delegatee)
        ERC721("Delegator NFT", "DNFT")
    {
        DELEGATEE = delegatee;
    }

    function getTimeDelegated(uint nftId) public view returns(uint) {
        return block.timestamp - stakes[nftId].startTimestamp;
    }

    function executeDelegate(address tokenAddress) public
    {
        IGovernanceToken(tokenAddress).delegate(DELEGATEE);
    }

    function delegateAndMint(uint amount, address tokenAddress) public {
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);

        _mint(msg.sender, nftCount);
        stakes[nftCount] = Stake(
            amount, 
            block.timestamp,
            tokenAddress
            );
        nftCount += 1;
    }

    function undelegateAndBurn(uint nftId) public {
        require(msg.sender == ownerOf(nftId), "Must be nft owner");
        _burn(nftId);
        address tokenAddress = stakes[nftId].tokenAddress;
        uint amount = stakes[nftId].amount;
        IERC20(tokenAddress).transfer(msg.sender, amount); //ToDo: currently blocked by Diva
    }
}
