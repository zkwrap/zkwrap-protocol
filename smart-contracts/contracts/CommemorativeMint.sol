//SPDX-License-Identifier: MIT

//Author : ZK Wrap

pragma solidity >= 0.8.0;

//will act as a faucet too
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract WaitlistMint is IERC721 , ERC165, Ownable{
    using SafeMath for uint256;
    using Address for address;

    string public constant Name = "ZK Wrap Commemorative Edition";
    string public constant Symbol = "ZK-Wrap";
    string public tokenURI;

    address private DepositHandler;

    mapping (address=>uint256) private balancesFaucet;
    mapping(address=>bool) private hasClaimedFaucet;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => bool) private hasMinted;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    event FormFilled(address indexed user);
    event CollectedFromFaucet(address indexed user);

    constructor (address _owner , string memory _uri){
        DepositHandler = _owner;
        tokenURI = _uri;
    }
    receive() external payable {}
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    } 
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }
    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = _ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }
     function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return _tokenApprovals[tokenId];
    }
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }
    function BaseURI(uint256 tokenId) public view returns (string memory) {
        _requireMinted(tokenId);
        return tokenURI;
    }
    function symbol() public view returns (string memory) {
        return Symbol;
    }
    function name() public view returns (string memory) {
        return Name;
    }
    function approve(address to, uint256 tokenId) public virtual override {
        address owner =ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner or approved for all"
        );

        _approve(to, tokenId);
    }
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");

        _transfer(from, to, tokenId);
    }
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(from, to, tokenId, data);
    }
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }
    //mint
    function _mint(address to, uint256 tokenId) internal virtual { 
        require(to != address(0), "ERC721: mint to the zero address");
        require(hasMinted[msg.sender] == false);
        require(!_exists(tokenId), "ERC721: token already minted");
        _beforeTokenTransfer(address(0), to, tokenId, 1);
        require(!_exists(tokenId), "ERC721: token already minted");
        unchecked {
            _balances[to] += 1;
        }
        _owners[tokenId] = to;
        hasMinted[msg.sender] = true;
        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);
    }
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
        _beforeTokenTransfer(from, to, tokenId, 1);
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        delete _tokenApprovals[tokenId];
        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId, 1);
    }
    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
    function __unsafe_increaseBalance(address account, uint256 amount) internal {
        _balances[account] += amount;
    }

    function supplyFaucet(uint256 amount) external payable returns(bool){
        require ( msg.sender == DepositHandler , "DO NOT HAVE ACCESS");
        require(amount > 0, "Cannot lock 0 Ether");
        require(msg.value == amount, "Amount sent does not match specified amount");
        balancesFaucet[msg.sender] = balancesFaucet[msg.sender].add(amount);
        return true;
    }

    function claimGas() public { // lets users claim gas to mint the nft
        uint256 amount = 10000000000000000;
        require(hasClaimedFaucet[msg.sender] == false, "Already Claimed Gas");
        require(balancesFaucet[DepositHandler] < amount ,"Faucet Running Dry!! If You Wish to Donate to Faucet Please Contact the Team");
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        balancesFaucet[DepositHandler] = balancesFaucet[DepositHandler].sub(amount);
        hasClaimedFaucet[msg.sender] = true;
    } 
     function getFaucetBalance() external view returns (uint256) {
        return balancesFaucet[DepositHandler];
    }
    function changeDepositor(address newDepositor) external {
        require(msg.sender == DepositHandler,"No Permission");
        DepositHandler = newDepositor;
    }
}