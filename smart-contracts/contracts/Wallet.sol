//SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Locker is Ownable , ReentrancyGuard{
    using SafeMath for uint256;

    struct Time {
        uint256 timestampOfAccessGrant;
        uint256 timestampOfAccessRemove;
    }

    address private Owner;
    
    mapping (address => uint256) private _balancesEth;
    mapping (address => Time) private _owners;
    mapping(address => bool) private _HasAccess;

    event EtherLocked(address indexed sender, uint256 amount ,uint256 timestamp);
    event EtherWithdrawn(address indexed receiver , uint256 amount , uint256 timestamp);
    event OwnerAdded(address indexed newOwner , uint256 timestamp);
    event OwnerRemoved(address indexed removedWhom , uint256 timestamp);
    event PrimaryOwnerChanged(address indexed newPrimaryOwner , uint256 timestamp);

    constructor (address Primary_owner){
        require (Primary_owner != address(0), "cannot be zero addr");
        Owner = Primary_owner; //nft contract
    }
    function LockEther(uint256 amount) external payable nonReentrant returns(bool){
        require ( msg.sender == Owner , "DO NOT HAVE ACCESS");
        require(amount > 0, "Cannot lock 0 Ether");
        require(msg.value == amount, "Amount sent does not match specified amount");
        _balancesEth[msg.sender] = _balancesEth[msg.sender].add(amount);
        emit EtherLocked(msg.sender, msg.value, block.timestamp);
        return true;
    }
    function WithdrawEther(uint256 amount) external nonReentrant returns(bool){
        require (_HasAccess[msg.sender] == true || msg.sender == Owner, "DO NOT HAVE ACCESS");
        require(amount > 0, "Cannot Withdraw 0 Ether");
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        _balancesEth[Owner] = _balancesEth[Owner].sub(amount);
        emit EtherWithdrawn(msg.sender, amount, block.timestamp);
        return true;
    }
    function getBalance() external view returns (uint256) {
        return _balancesEth[Owner];
    }
    function AddOwner(address newOwner) external returns(bool){
        require (msg.sender == Owner ,"Not the Primary Owner");
        require(newOwner != address(0), "Invalid address");
        require(!_HasAccess[newOwner], "Address already has access");
        _HasAccess[newOwner] = true;
        _owners[newOwner] = Time(block.timestamp, 0);
        emit OwnerAdded(newOwner , block.timestamp);
        return true;
    }
    function RemoveOwner(address toRemove) external returns(bool){
        require (msg.sender == Owner ,"Not the Primary Owner");
        require(toRemove != address(0), "Invalid address");
        require(_HasAccess[toRemove], "Address already has access");
        _HasAccess[toRemove] = false;
        _owners[toRemove] = Time(0, block.timestamp);
        emit OwnerRemoved(toRemove , block.timestamp);
        return true;
    }

    function CheckStat(address adminAddr) external view returns(uint256 , uint256) {
        return (_owners[adminAddr].timestampOfAccessGrant, _owners[adminAddr].timestampOfAccessRemove);
    }

    function hasAdminAccess(address AddressToCheck) external view returns(bool){
        return _HasAccess[AddressToCheck];
    }
    function ChangePrimaryOwner(address newOwner) external returns(bool){
        require (msg.sender == Owner , "Only Primary Owner Can do that");
        require(newOwner != address(0) , "Cannot be Zero Address");
        Owner = newOwner;
        emit PrimaryOwnerChanged(newOwner , block.timestamp);
        return true;
    }
    receive() external payable {}
}