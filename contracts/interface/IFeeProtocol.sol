// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
// File: /contracts/interface/IFeeProtocol.sol

/**
 * @dev Interface of the charge fee
 * Basic Fee 15%
 * If there is an expedition this will reduce the commission by 5%
 * If you have NFT, the commission will be reduced by 5%.
 */
interface IFeeProtocol {
    /**
     * @dev Set fee of the address.
     *
     * Returns whether the address fee is set successfully.
     *
     */
    function setGameFee(address account) external returns(bool);


    /**
     * @dev Acquisition fee of the address.
     *
     * Returns the fee for the address in the protocols.
     *
     */
    function getFee(address account) external view returns (uint256);

    /**
     * @dev Determine the validity of the address.
     *
     * Returns a boolean value whether the contract contains the address.
     *
     */
    function contains(address account) external view returns (bool);
}
