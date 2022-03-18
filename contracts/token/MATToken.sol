// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./ERC20/ERC20.sol";
import "../utils/Ownable.sol";
import "../interface/IFeeProtocol.sol";

// File: /contracts/token/MATToken.sol

/// @title MATToken - Game Bevil Magic Token ERC20 implementation
/// @notice Simple implementation of a {ERC20} token to be used as
// Bevil (MAT)
contract MATToken is ERC20  {
    uint256 ratio = 10000;
    uint256 basicFee = 1500;
    uint256 buyBoxFee = 500;
    uint256 supply = 120000000 * 10 ** decimals();
    address feeContract;

    /**
     * @dev  Allocation to each channel
     * liquidity 1% share
     * gameAward 99% share
     */
    constructor(address gameContract,
        address expeditionContract) ERC20('Bevil Magic Token', 'MAT'){
        uint256 liquidity = supply / 100;
        _mint(msg.sender, liquidity);
        _mint(gameContract, supply - liquidity);
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
     * @dev buy props
     * Purchase monster game items
     */
    function buyProps(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @dev trade box
     * Transaction treasure box charging 5% commission,
     * %5 for burning
     */
    function buyBox(address recipient, uint256 amount) public virtual {
        uint256 destroyAmount = amount * buyBoxFee / ratio;
        _burn(msg.sender, destroyAmount);
        super.transfer(recipient, amount - destroyAmount);
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
        if(fee !=0){
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
