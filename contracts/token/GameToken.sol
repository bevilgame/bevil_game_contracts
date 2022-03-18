// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC721/extensions/ERC721Enumerable.sol";
import "./ERC721/extensions/ERC721URIStorage.sol";
import "../utils/Ownable.sol";
import "../interface/IGameProtocol.sol";


/// @title GameProtocol - Game Bevil The gameplay
/// @notice Simple implementation of a {ERC721} token to be used as
// Bevil Monster Token (BMT)
contract GameToken is ERC721Enumerable, ERC721URIStorage, Ownable {
    string private _contractURI;
    uint256 private TOTAL_SUPPLY = 100000;
    uint256 private _tokenId = 1000;
    string private tokenBaseUri;
    uint256 private PRICE = 59 * (10 ** 18);
    uint256 private USDT_PRICE = 59 * (10 ** 18);
    address private feeContract;
    address private tokenContract;
    address private usdtContract = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    // prd config
    constructor() ERC721("BevilMonsterToken", "BMT") {
        string memory baseURI = "https://bevil.io";
        tokenBaseUri = string(abi.encodePacked(baseURI, "/api/token/2/"));
        _contractURI = string(abi.encodePacked(baseURI, "/api/token/info"));
    }

    /*
     * @dev Use USDT to purchase blind boxes
     * Params: Pass in the purchase quantity and amount
     * Returns the tokenId of NFT
     */
    function usdtOpenMore(uint num, uint256 amount) public virtual returns (uint256[] memory) {
        require(num > 0, "open number must be great than 0");
        require(amount >= USDT_PRICE * num, "amount not enough to open box");
        IFeeProtocol(usdtContract).transferFrom(msg.sender, address(this), amount);
        uint256[] memory tokens = new uint256[](num);
        for (uint256 i = 0; i < num; i++) {
            _tokenId++;
            _mint(msg.sender, _tokenId);
            tokens[i] = _tokenId;
        }
        return tokens;
    }

    /*
     * @dev Use Bevil Token to purchase blind boxes
     * Params: Pass in the purchase quantity and amount
     * Returns the tokenId of NFT
     */
    function openMore(uint num, uint256 amount) public virtual returns (uint256[] memory) {
        require(num > 0, "open number must be great than 0");
        require(amount >= PRICE * num, "amount not enough to open box");
        IFeeProtocol(tokenContract).contractTransfer(msg.sender, address(this), amount);
        IFeeProtocol(feeContract).setGameFee(msg.sender);
        uint256[] memory tokens = new uint256[](num);
        for (uint256 i = 0; i < num; i++) {
            _tokenId++;
            _mint(msg.sender, _tokenId);
            tokens[i] = _tokenId;
        }
        return tokens;
    }

    /*
     * @dev Use Frag to assemble blind boxes for admin
     * Params: Pass in the purchase quantity and amount
     * Returns the tokenId of NFT
     */
    function giveMore(address _to, uint num) public onlyOwner returns (uint256[] memory) {
        require(num > 0, "give number must be great than 0");
        uint256[] memory tokens = new uint256[](num);
        for (uint256 i = 0; i < num; i++) {
            _tokenId++;
            _mint(_to, _tokenId);
            tokens[i] = _tokenId;
        }
        return tokens;
    }


    function sellBox() public payable returns(bool) {
        payable(address(this)).transfer(msg.value);
        return true;
    }

    function getAllTokenIds() public view returns (uint256[] memory ids){
        uint256 length = balanceOf(msg.sender);
        uint256[] memory _ids = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            _ids[i] = tokenOfOwnerByIndex(msg.sender, i);
        }
        return _ids;
    }

    function getAllTokenIdsByOwner(address owner) public view  returns (uint256[] memory ids){
        uint256 length = balanceOf(owner);
        uint256[] memory _ids = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            _ids[i] = tokenOfOwnerByIndex(owner, i);
        }
        return _ids;
    }

    function setTokenContract(address _contract) public onlyOwner returns(bool){
        tokenContract = _contract;
        return true;
    }

    function setFeeContract(address _contract) public onlyOwner returns(bool){
        feeContract = _contract;
        return true;
    }

    function getContractAddress(uint _type) public onlyOwner view returns(address){
        return _type == 1 ? feeContract : tokenContract;
    }

    function setPrice(uint256 _price) public virtual onlyOwner {
        PRICE = _price;
    }

    function getPrice() public view returns(uint256) {
        return PRICE;
    }

    function totalCount() public view returns (uint256){
        return super.totalSupply();
    }

    function setTokenURI(string memory uri) public onlyOwner {
        tokenBaseUri = uri;
    }

    function setContractURI(string memory uri) public onlyOwner {
        _contractURI = uri;
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return tokenBaseUri;
    }

    // @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }


    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     */
    function totalSupply() public view virtual override(ERC721Enumerable) returns (uint256) {
        return TOTAL_SUPPLY;
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {
    }

    // Fallback function is called when msg.data is not empty
    fallback() external payable {
    }

}
