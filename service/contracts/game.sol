// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./diamonds.sol";
import "./worker.sol";
import "./hoe.sol";

contract Game {
    
    Diamonds private _diamonds;

    Worker private _worker;

    Hoe private _hoe;

    constructor(address diamondsAddr,address workerAddr,address hoeAddr){
        _diamonds=Diamonds(diamondsAddr);
        _worker=Worker(workerAddr);
        _hoe=Hoe(hoeAddr);
    }

    //金矿概率,界面除以100就是概率2400
    function goldRate(uint256 workerId,uint256 hoeId)public view returns(uint256){
        return (_worker.props(workerId)*10+_hoe.props(hoeId)*2)*2;
    }

    //银矿概率6000
    function silverRate(uint256 workerId,uint256 hoeId)public view returns(uint256){
        return (_worker.props(workerId)*10+_hoe.props(hoeId)*2)*5;
    }

    //铜矿概率9600
    function copperRate(uint256 workerId,uint256 hoeId)public view returns(uint256){
        return (_worker.props(workerId)*10+_hoe.props(hoeId)*2)*8;
    }

    event Dig(bool successed);

    function dig(uint256 workerId,uint256 hoeId,uint8 _type) public{
        require(_worker.ownerOf(workerId)==msg.sender,"player and worker not matched");
        require(_hoe.ownerOf(hoeId)==msg.sender,"player and hoe not matched");
        require(digAlow(workerId,hoeId),"dig not allow");
        _worker.dig(msg.sender,workerId);
        _hoe.dig(msg.sender,hoeId);
        uint256 rate;
        uint256 money;
        if(_type==1){
            rate=goldRate(workerId,hoeId);
            money=8;
        }else if(_type==2){
            rate=silverRate(workerId,hoeId);
            money=3;
        }else if(_type==3){
            rate=copperRate(workerId,hoeId);
            money=1;
        }
        uint256 result=rand(10000,0);
        if(rate>=result){
            //获胜发放奖励
            _diamonds.mint(msg.sender,money*10**18);
            emit Dig(true);
        }else{
            emit Dig(false);
        }
    }

    function digAlow(uint256 workerId,uint256 hoeId)public view returns(bool){
        if(_worker.digAlow(workerId)&&_hoe.digAlow(hoeId)){
            return true;
        }
        return false;
    }
    
    function rand(uint256 _length,uint256 _nonce) public view returns(uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp,_nonce)));
        return random%_length+1;
    }

}