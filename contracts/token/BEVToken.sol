// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC20/ERC20.sol";
import "../interface/IFeeProtocol.sol";
// File: /contracts/token/BEVToken.sol

/// @title BEVToken - Game Bevil Monster Token ERC20 implementation
/// @notice Simple implementation of a {ERC20} token to be used as
// Bevil (BEV)
contract BEVToken is ERC20 {
    uint256 ratio = 10000;
    uint256 basicFee = 1500;
    uint256 supply = 12000000 * 10 ** decimals();
    address feeContract;
    /**
     * @dev  Allocation to each channel
     * teamContract 12% share
     * foundation 5% share
     * gameContract 43% share
     * liquidity 10% share
     * lpsPoolContract 30% share
     */
    //    constructor(address expeditionContract,
    //                address gameContract,
    //                address teamContract,
    //                address foundation,
    //                address liquidity) ERC20('Bevil', 'BEV'){
    //        _mint(teamContract, supply * 1200 / ratio);
    //        _mint(foundation, supply * 500 / ratio);
    //        _mint(gameContract, supply * 4300 / ratio);
    //        _mint(liquidity, supply * 1000 / ratio);
    //        _mint(lpsPoolContract, supply * 3000 / ratio);
    //         feeContract = expeditionContract;
    //    }

    constructor(address gameContract,
        address expeditionContract) ERC20('Bevil', 'BEV'){
        _mint(_msgSender(), supply * 1200 / ratio);
        _mint(gameContract, supply * 4300 / ratio);
        _mint(expeditionContract, supply * 3000 / ratio);
        feeContract = expeditionContract;
    }

    /*
     * @dev transfer without fee, offer contract use
     * Currently available for game contracts
     */
    function contractTransfer(address from, address to, uint256 amount) public virtual returns (bool) {
        require(IFeeProtocol(feeContract).contains(to), 'need contract use');
        super.transferFrom(from, to, amount);
        return true;
    }

    /**
     * @dev See {ERC20-transfer}.
     * If there is an expedition this will reduce the commission by 5%
     * If you have NFT, the commission will be reduced by 5%
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override(ERC20) returns (bool) {
        uint256 fee = IFeeProtocol(feeContract).getFee(msg.sender);
        uint256 destroyFee = amount * fee / ratio;
        if(fee !=0) {
            _burn(msg.sender, destroyFee);
        }
        super.transfer(to, amount - destroyFee);
        return true;
    }

    /**
     * @dev See {ERC20-transferFrom}.
     * The BaseFee is 15%
     * If there is an expedition this will reduce the commission by 5%
     * If you have NFT, the commission will be reduced by 5%
     *
     * Requirements:
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override(ERC20) returns (bool) {
        uint256 fee = IFeeProtocol(feeContract).getFee(from);
        uint256 destroyFee = amount * fee / ratio;
        if(fee !=0){
            _burn(from, destroyFee);
        }
        super.transferFrom(from, to, amount - destroyFee);
        return true;
    }
}

