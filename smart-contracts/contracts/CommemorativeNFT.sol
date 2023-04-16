//SPDX-License-Identifier: MIT

/**
 * @title ZKWRAP MINT NFT FOR WHITELIST
 * @author ZKWRAP TEAM ( BOBSEAL & RAAZY )
 */

pragma solidity >= 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CommemorativeNFT is ERC721 {
    using SafeMath for uint256;
    using Address for address;

    string public constant Name = "ZK Wrap Commemorative Edition";
    string public constant Symbol = "ZK-Wrap";
    string public tokenURI;
    uint256 tokenID;

    uint256 mintLimit;
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

    constructor () ERC721(Name, Symbol) {
        DepositHandler = msg.sender;
        tokenURI = "https://bafybeieaaadnnexmnzr6es6xopicjl3vilg5h5pehfegueiioogvsp4zey.ipfs.dweb.link/";
        tokenID = 0;
        mintLimit = 5000;
    }

    receive() external payable {}
    
    /**
     * @dev supply faucet to user ( this function gets called on claimFaucet function )
     * @param amount 
     */
    function supplyFaucet(uint256 amount) internal payable returns(bool){
        require ( msg.sender == DepositHandler , "DO NOT HAVE ACCESS");
        require(amount > 0, "Cannot lock 0 Ether");
        require(msg.value == amount, "Amount sent does not match specified amount");

        (bool success, ) = payable(msg.sender).call{value: msg.value}("");
        require(success);
        return true;
    }

    /**
     * @dev let user claim some faucet for paying gass fee
     */
    function claimFaucet() public { // lets users claim gas to mint the nft
        uint256 amount = 2000000000000000; //0.002
        require(hasClaimedFaucet[msg.sender] == false, "Already Claimed Gas");
        require(hasMinted[msg.sender] == false,"Already Minted, Gas Access Denied");
        require(balancesFaucet[DepositHandler] > amount * 2 ,"Faucet Running Dry!! If You Wish to Donate to Faucet Please Contact the Team");

        hasClaimedFaucet[msg.sender] = true;
        supplyFaucet();
    } 


    function getFaucetBalance() external view returns (uint256) {
        return balancesFaucet[DepositHandler];
    }

    /**
     * @dev change the depositor
     * @param newDepositor 
     */
    function changeDepositor(address newDepositor) external {
        require(msg.sender == DepositHandler,"No Permission");
        DepositHandler = newDepositor;
    }

    //Mint for Users
    /**
     * @dev mint nft
     * @return boolean
     */
    function ClaimNFT() public returns(bool){
        require(hasMinted[msg.sender] == false,"only 1 nft per wallet allowed");
        _mint(msg.sender, tokenID);
        tokenID++;
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
        return true;
    }
}