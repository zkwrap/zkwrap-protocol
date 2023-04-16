//SPDX-License-Identifier: MIT

/**
 * @title ZKWRAP MINT NFT FOR WHITELIST
 * @author ZKWRAP TEAM ( BOBSEAL & RAAZY )
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error SUPPLY_FAILED(string message);

contract CommemorativeNFT is ERC721 {
    // TYPE DEFINITIONS
    using SafeMath for uint256;
    using Address for address;

    // STATE VARIABLES
    string public constant Name = "ZK Wrap Commemorative Edition";
    string public constant Symbol = "ZK-Wrap";
    string public tokenURI;
    uint256 tokenID;
    uint256 private minimalFaucetAmount = 0.01 ether;
    uint256 mintLimit;
    address private DepositHandler;
    
    // MAPPINGS
    mapping(address => bool) private faucetHasClaimed;
    mapping (address=>uint256) private balancesFaucet;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(address => bool) private hasMinted;

    // EVENTS
    event FormFilled(address indexed user);
    event CollectedFromFaucet(address indexed user);
    event FAUCET_SUPPLIED(uint256 indexed faucetAmount, address indexed supplier);
    event FAUCET_CLAIMED(address indexed claimer, uint claimedAmount);
    event LIMIT_EXTENDED(address indexed extender);
    event NFT_CLAIMED(address indexed claimer, uint tokenId);

    constructor () ERC721(Name, Symbol) payable {
        DepositHandler = msg.sender;
        tokenURI = "https://bafybeieaaadnnexmnzr6es6xopicjl3vilg5h5pehfegueiioogvsp4zey.ipfs.dweb.link/";
        tokenID = 0;
        mintLimit = 5000;

        // supply initial faucet to FAUCET WALLET 
        (bool supplied, ) = payable(DepositHandler).call{value: msg.value}("");
    }

    receive() external payable {}


    // ----------------- SETTER FUNCTIONS ---------------
    
    /**
     * @dev supply faucet to FAUCET WALLET ( see: DepositHandler state variable )
     * @return boolean
     */
    function supplyFaucet(uint faucetAmount) internal payable returns(bool){
        require ( msg.sender == DepositHandler , "DO NOT HAVE ACCESS");
        require(msg.value == faucetAmount || msg.value > faucetAmount);

        (bool supplied, ) = payable(DepositHandler).call{value: msg.value}("");
        if(!supplied) {
            revert SUPPLY_FAILED("FAUCET SUPPLY FAILED");
        }

        emit FAUCET_SUPPLIED(faucetAmount, msg.sender);
        return true;
    }

    /**
     * @dev let user claim some faucet for paying gass fee on mint nft
     * @return boolean
     */
    function claimFaucet() public payable returns(bool) { // lets users claim gas to mint the nft
        uint256 balanceLeft = 0.002 ether; //0.002
        require(DepositHandler.balance > balanceLeft ,"Faucet Running Dry!! If You Wish to Donate to Faucet Please Contact the Team");
        require(!faucetHasClaimed[msg.sender], "FAUCET: PER USER ONLY CAN CLAIM ONCE");
        require(msg.value < minimalFaucetAmount || msg.value == minimalFaucetAmount , "faucet: faucet amount must be equal or above minimalFaucetAmount");
        uint faucetAmount = DepositHandler.balance - msg.value;

        faucetHasClaimed[msg.sender] = true;
        (bool success, ) = payable(msg.sender).call{value: faucetAmount}("");
        require(success);

        emit FAUCET_CLAIMED(msg.sender, faucetAmount);
        return true;
    } 

    /**
     * @dev change the depositor
     * @param newDepositor 
     */
    function changeDepositor(address newDepositor) external {
        require(msg.sender == DepositHandler,"No Permission");
        DepositHandler = newDepositor;
    }

    /**
     * @dev mint nft => per user can only mint once
     * @return boolean
     */
    function claimNFT() public returns(bool){
        require(!hasMinted[msg.sender],"only 1 nft per wallet allowed");
        tokenID++;
        _mint(msg.sender, tokenID);

        emit NFT_CLAIMED(msg.sender, tokenID);
        return true;
    }

    /**
     * @dev extend limit of whitelist/ total nft supply
     * @param newLimit ( typeof uint256 ) 
     * @return boolean
     */
    function extendMintLimit(uint256 newLimit) external returns(bool){
        require(msg.sender == DepositHandler,"Depositor Has the Permission");
        mintLimit = newLimit;

        emit LIMIT_EXTENDED(msg.sender);
        return true;
    }

    // ------------------- GETTER FUNCTIONS -----------------
    /**
     * @dev get balance of FAUCET WALLET
     * @return uint256
     */
    function getFaucetBalance() external view returns (uint256) {
        return DepositHandler.balance;
    }
}