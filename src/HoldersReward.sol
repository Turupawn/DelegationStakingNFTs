// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "./DelegateReward.sol";

contract HoldersReward is ERC721 {
    address DELEGATE_REWARD;
    address TOKEN_ADDRESS;
    uint TIME_DELEGATED;

    uint nftCount;

    mapping(uint nftId => bool) hasMinted;

    constructor(address delegateReward, address tokenAddress, uint timeDelegated)
        ERC721("Reward NFT", "DNFT")
    {
        DELEGATE_REWARD = delegateReward;
        TOKEN_ADDRESS = tokenAddress;
        TIME_DELEGATED = timeDelegated;
    }

    function claim(uint nftId) public {
        //require(IERC721(DELEGATE_REWARD).ownerOf(nftId) == msg.sender, "Must be token owner");
        require(TIME_DELEGATED >= DelegateReward(DELEGATE_REWARD).getTimeDelegated(nftId), "Must wait for delegation time");
        require(!hasMinted[nftId], "Already minted");
        hasMinted[nftId] = true;
        _mint(IERC721(DELEGATE_REWARD).ownerOf(nftId),nftCount);
        nftCount+=1;
    }
}
