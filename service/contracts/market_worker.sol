// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./diamonds.sol";
import "./worker.sol";
import "./util/contracts/access/Ownable.sol";
import "./util/safemath.sol";

contract MarketWorker is Ownable{
    using SafeMath for uint256;
    
    Diamonds private _diamonds;

    Worker private _worker;

    constructor(address diamondsAddr,address workerAddr){
        _diamonds=Diamonds(diamondsAddr);
        _worker=Worker(workerAddr);
    }
    
    struct Sales{
        address seller;
        uint price;
    }
    mapping(uint=>Sales) public shop;
    uint shopCount;
    uint public minPrice = 1*10**18;

    event Sale(uint indexed tokenId,address indexed seller);
    event Cancel(uint indexed tokenId,address indexed seller);
    event Buy(uint indexed tokenId,address indexed buyer,address indexed seller);

    function sale(uint _tokenId,uint _price)public{
        require(_price>=minPrice,'Your price not alow');
        require(_worker.ownerOf(_tokenId)==msg.sender,"token not alow");
        shop[_tokenId] = Sales(msg.sender,_price);
        shopCount = shopCount.add(1);
        _worker.setMoveNft(msg.sender,address(this),true);
        emit Sale(_tokenId,msg.sender);
    }

    function cancel(uint _tokenId)public{
        require(_worker.ownerOf(_tokenId)==msg.sender,"token not alow");
        delete shop[_tokenId];
        _worker.setMoveNft(msg.sender,address(this),false);
        shopCount = shopCount.sub(1);
        emit Cancel(_tokenId,msg.sender);
    }

    function buy(uint _tokenId)public{
        require(_diamonds.balanceOf(msg.sender) >= shop[_tokenId].price,'No enough money');
        _diamonds.transferRole(msg.sender,shop[_tokenId].seller,shop[_tokenId].price);//合约转账给卖家
        _worker.safeTransferFrom(shop[_tokenId].seller,msg.sender,_tokenId);//合约将卖家的nft转给买家
        delete shop[_tokenId];
        shopCount = shopCount.sub(1);
        emit Buy(_tokenId,msg.sender,shop[_tokenId].seller);
    }

    function getShop() external view returns(uint[] memory) {
        uint[] memory result = new uint[](shopCount);
        uint counter = 0;
        for (uint i = 1; i <= _worker.tokenIds(); i++) {
            if (shop[i].price != 0) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function setMinPrice(uint _value)public onlyOwner{
        minPrice = _value;
    }
}