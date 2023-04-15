// SPDX-Licence-Identifier : MIT

///AUTHOR : ZKWRAP
///CONTRIBUTOR : BOBSEAL

pragma solidity ^0.8.17;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WRAPTOKEN is IERC20 {
    using SafeMath for uint256;
    string public name = "ZK WRAP";
    string public symbol ="RAP";
    uint256 public constant decimals = 18;
    uint256 public fee1;
    uint256 public fee2;
    uint256 public fee3;
    uint256 private maxTx;
    address private address1;
    address private address2;
    address private address3;
    address private Owner;
    uint256 private maxHoldLimit; // max limit per wallet to hold
    uint256 public _totalSupply;
    bool private lockedSwap;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _excludedFromHoldLimit;
    mapping(address => bool) private _excludedFromTxLimit;
    event ExcludeFromFee(address indexed account, bool isExcluded);
    event SetFeePercentage(uint256 feePercentage , uint256 timestamp);
    event Rebrand (string name , string symbol , uint256 timestamp);
    event TransferOwnership(address indexed previousOwner , address indexed newOwner , uint256 timestamp);
    event TransactionStatus(bool TransactionsEnabled , uint256 timestamp);

    constructor(string memory _name , string memory _symbol,address _feereceiever1 , address _feereceiever2 , uint256 feea , uint256 feeb, uint256 feec , uint256 maxTxPercent , uint256 supply , uint256 maxWalletLimit) {
        _totalSupply = supply * (10**18);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
        address1 = _feereceiever1; // fee recieving wallets ... Ecosystem MultiSig Wallet for the Ecosystem Revenue and Run Costs
        address2 = _feereceiever2; // Ecosystem Multisig Reward and Incentive Pool
        address3 = address(0); // burn this amount
        fee1 = feea;  // 1 = 0.01%
        fee2 = feeb;
        fee3 = feec;
        maxTx= maxTxPercent;
        name=_name;
        symbol=_symbol;
        maxHoldLimit = maxWalletLimit;
        Owner = msg.sender;
        lockedSwap = false;
    }
    function rebrandToken(string memory newname , string memory newsymbol) public returns(bool) {
        require(msg.sender == owner(), "Only the owner can set the Logo");
        name = newname;
        symbol = newsymbol;
        emit Rebrand(newname , newsymbol , block.timestamp);
        return true;
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
     function totalUnburntSupply() public view returns (uint256) {
        uint256 totSupply = _totalSupply - _balances[address3];
        return totSupply;
    }
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    function allowance(address owwner, address spender) public view returns (uint256) {
        return _allowances[owwner][spender];
    }
    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transfer(address recipient, uint256 amount) public returns (bool) {
        if (!_isExcludedFromFee[msg.sender]) {
            uint256 feeAmount1 = amount.mul(fee1).div(10000);
            uint256 feeAmount2 = amount.mul(fee2).div(10000);
            uint256 feeAmount3 = amount.mul(fee3).div(10000);
            uint256 totalFee = feeAmount1.add(feeAmount2).add(feeAmount3);
            uint256 amtAfterFee = amount.sub(totalFee);
            _transfer(msg.sender, recipient, amtAfterFee);
            _transfer(msg.sender, address1, feeAmount1);
            _transfer(msg.sender, address2, feeAmount2);
            _transfer(msg.sender, address3, feeAmount3);
        }
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _allowances[sender][msg.sender] = currentAllowance.sub(amount);
        if (!_isExcludedFromFee[msg.sender]) {
            uint256 feeAmount1 = amount.mul(fee1).div(1000);
            uint256 feeAmount2 = amount.mul(fee2).div(1000);
            uint256 feeAmount3 = amount.mul(fee3).div(1000);
            uint256 totalFee = feeAmount1.add(feeAmount2).add(feeAmount3);
            uint256 amtAfterFee = amount.sub(totalFee);
            _transfer(sender, recipient, amtAfterFee);
            _transfer(sender, address1, feeAmount1);
            _transfer(sender, address2, feeAmount2);
            _transfer(sender, address3, feeAmount3);
        } else {
            _transfer(sender, recipient, amount);
        }
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(lockedSwap == false ,"Transacitons are temporarily disabled for this token");
        uint256 outAmt= _totalSupply.mul(maxTx).div(100);
        uint256 senderLim = _totalSupply.mul(maxHoldLimit).div(100);
        if (!_excludedFromTxLimit[msg.sender]){
        require(amount <= outAmt,"Amount Exceeds Allowed Transaction Limit, Retry or get Permission");
        }
        if(!_excludedFromHoldLimit[msg.sender]){
        require (_balances[recipient].add(amount) < senderLim , "The Reciever Balance is already max of what is allowed to hold");
        }
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance.sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function setFee(uint256 _fee1, uint256 _fee2, uint256 _fee3) public returns(bool) {
        require(msg.sender == owner(), "Only the owner can set the fee");
        fee1 = _fee1;
        fee2 = _fee2;
        fee3 = _fee3;
        emit SetFeePercentage(_fee1 + _fee2 + _fee3 , block.timestamp);
        return true;
    }
    function burn(uint256 amount) public returns(bool) {
        require(_balances[msg.sender] >= amount, "ERC20: burn amount exceeds balance");
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }
    function isApproved(address account) public view returns (bool) {
        return _allowances[account][owner()] > 0;
    }
    function setAddress(address _address1, address _address2, address _address3) public returns(bool) {
        require(msg.sender == owner(), "Only the owner can set the address");
        address1 = _address1;
        address2 = _address2;
        address3 = _address3;
        return true;
    }
    function excludeFromFee(address account) public returns(bool){
        require(msg.sender == owner(), "Only the owner can exclude addresses from fees");
        require(_isExcludedFromFee[account] == false ,"account already excluded");
        _isExcludedFromFee[account] = true;
        emit ExcludeFromFee(account, true);
        return true;
    }
    function includeInFee(address account) public returns(bool) {
        require(msg.sender == owner(), "Only the owner can exclude addresses from fees");
        require(_isExcludedFromFee[account] == true ,"account already included");
        _isExcludedFromFee[account] = false;
        emit ExcludeFromFee(account, false);
        return true;
    }
    function excludeFromTxLimit(address account) public returns(bool){
        require(msg.sender == owner(), "Only Owner Is allowed to call");
        require(_excludedFromTxLimit[account] == false , "account already excluded");
        _excludedFromTxLimit[account] = true;
        return true;
    }
    function includeInTxLimit(address account) public returns(bool){
        require(msg.sender == owner(), "Only Owner Is allowed to call");
        require(_excludedFromTxLimit[account] == true , "account already included");
        _excludedFromTxLimit[account] = false;
        return true;
    }
    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }
    function isExcludedFromTxLimit(address account) public view returns(bool){
        return _excludedFromTxLimit[account];
    }
    function excludefromHoldLimit(address account) public returns(bool) {
        require (msg.sender == owner() , "Only Owner Function");
        require(_excludedFromHoldLimit[account] == false , "Already Excluded");
        _excludedFromHoldLimit[account] = true;
        return true;
    }
    function includeInHoldLimit(address account) public returns(bool){
        require (msg.sender == owner() , "Only Owner Function");
        require(_excludedFromHoldLimit[account] == true , "Already Included");
        _excludedFromHoldLimit[account] = false;
        return true;
    }
    function isExcludedFromHoldLimit(address account) public view returns(bool){
        return _excludedFromHoldLimit[account];
    }
    function transferOwnership(address newOwner) public returns(bool){
        require (msg.sender == Owner,"OnlyOwner can do this");
        address oldOwner = Owner;
        Owner = newOwner;
        emit TransferOwnership(oldOwner , newOwner , block.timestamp);
        return true;
    }
    function owner() public view returns (address) {
        return Owner;
    }
    function lockSwap() public {
        require (msg.sender == Owner , "Cant Lock , needs to be owner");
        require(lockedSwap == false);
        lockedSwap = true;
        emit TransactionStatus(false , block.timestamp);
    }
    function unlockSwap() public {
        require (msg.sender == Owner , "Cant Lock , needs to be owner");
        require(lockedSwap == true);
        lockedSwap = false;
        emit TransactionStatus(true , block.timestamp);
    }
    function CheckIfSwapLocked() public view returns(bool){
        return lockedSwap;
    }
}