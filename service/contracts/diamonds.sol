// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./util/contracts/token/ERC20/ERC20.sol";
import "./util/contracts/access/AccessControl.sol";

contract Diamonds is ERC20, AccessControl{

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() ERC20("Diamonds", "DIA") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(address to,uint256 amount) public onlyRole(MINTER_ROLE) {
        _burn(to, amount);
    }

    function transferRole(address sender,address receiver,uint256 amount) public onlyRole(MINTER_ROLE) {
        _transfer(sender,receiver,amount);
    }
    
    function setRole(address addr) public onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(MINTER_ROLE,addr);
    }

    //兑换(合约收取eth后铸造代币给用户)
    function exchange() payable public {
        uint256 amountTobuy = msg.value;
        require(amountTobuy > 0, "You need to send some Ether");
        _mint(msg.sender, amountTobuy);
        emit Bought(amountTobuy);
    }

    //合约拥有者提取eth
    function withdawOwner(uint256 amount) public onlyRole(MINTER_ROLE){
        payable(msg.sender).transfer(amount);
        emit Sold(amount);
    }

    //汇率,100万则是1:1
    uint256 public rate=1000000;

    //手续费率0就是没有手续费，最高为100
    uint256 public charge=0;

    //提现：销毁代币，合约支付eth给用户。根据汇率兑换，扣除手续费
    function withdaw(uint256 amount) public{
        _burn(msg.sender,amount);
        payable(msg.sender).transfer(amount*rate/1000000-amount*charge/100);
        emit Sold(amount);
    }

    //转账代币给其他人
    function transferOther(address receiver,uint256 amount)public{
        transferFrom(msg.sender, receiver, amount);
    }

    function setRate(uint256 _rate) public onlyRole(MINTER_ROLE){
        rate=_rate;
    }

    function setCharge(uint256 _charge) public onlyRole(MINTER_ROLE){
        charge=_charge;
    }
}
