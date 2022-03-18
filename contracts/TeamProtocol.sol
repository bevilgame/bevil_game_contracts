// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interface/IGameProtocol.sol";
import "./utils/Ownable.sol";

// File: /contracts/TeamProtocol.sol

/// @title TeamProtocol - 12% of all BEVs as initial reward
/// @notice all initial team bonus, locked, 20% in one year, 5 years out,
// Bevil (MAT)
contract TeamProtocol is Ownable {
    uint256 onceInterval = 1 years;
    uint256 LockInterval = onceInterval;
    uint256 beginTime;
    uint256 totalAmount = 1440000 * 10 ** 18;
    uint256 thawAmount = 0;
    uint256 baseRatio = 2000;
    uint256 ratio = 10000;

    //Initial lock time
    constructor(){
        beginTime = block.timestamp;
    }

    /*
     * @dev BEV thawing method
     * Input reception and quantity, determine whether the time is met,
     * whether the amount is met
     */
    function thaw(address _contract, address recipient, uint256 amount) public onlyOwner returns(uint256) {
        require(block.timestamp - beginTime > LockInterval, "unlock time is not reached");
        require(thawAmount + amount <= totalAmount * baseRatio / ratio, 'the period amount more than limit');
        if(thawAmount + amount == totalAmount * baseRatio / ratio){
            LockInterval = LockInterval + onceInterval;
            baseRatio += baseRatio;
        }
        IFeeProtocol(_contract).transfer(recipient, amount);
        thawAmount = thawAmount + amount;
        return 0;
    }
}
