// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./util/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./util/contracts/utils/Counters.sol";
import "./util/contracts/access/AccessControl.sol";
import "./diamonds.sol";
import "./worker.sol";
import "./hoe.sol";

contract Box is AccessControl,ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    event OpenBox(uint256 leixing,uint256 create);

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    Diamonds private _diamonds;

    Worker private _worker;

    Hoe private _hoe;

    uint256 public price=1*10**18;//盲盒价格

    constructor(address diamondsAddr,address workerAddr,address hoeAddr) ERC721("Box", "BOX") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _diamonds=Diamonds(diamondsAddr);
        _worker=Worker(workerAddr);
        _hoe=Hoe(hoeAddr);
    }
    
    function supportsInterface(bytes4 interfaceId)public view override(ERC721, AccessControl)returns (bool){
        return super.supportsInterface(interfaceId);
    }

    function setRole(address addr) public onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(MINTER_ROLE,addr);
    }

    function setPrice(uint256 _price) public onlyRole(DEFAULT_ADMIN_ROLE){
        price=_price;
    }
    
    //铸造box
    function mint(address player, string memory tokenURI)public onlyRole(MINTER_ROLE) returns(uint256){
        return create(player,tokenURI);
    }

    function create(address player, string memory tokenURI) internal returns(uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    //销毁(使用)box
    function burn(uint256 tokenId) public{
        require(_exists(tokenId), "_tokenId for nonexistent token");
        _burn(tokenId);
        uint256 r=rand(20,0);
        if(r>=10){
            uint256 itemId=_worker.mintWorker(msg.sender,"");
            emit OpenBox(1,itemId);
        }else{
            uint256 itemId=_hoe.mintHoe(msg.sender,"");
            emit OpenBox(2,itemId);
        }
    }
    //消耗diamonds购买盲盒
    function buyBox()public{
        uint256 balance=_diamonds.balanceOf(msg.sender);
        require(balance >=price, "diamonds Not enough");
        _diamonds.burn(msg.sender,price);//销毁用户代币
        uint256 r=rand(20,0);
        if(r>=10){
            uint256 itemId=_worker.mintWorker(msg.sender,"");
            emit OpenBox(1,itemId);
        }else{
            uint256 itemId=_hoe.mintHoe(msg.sender,"");
            emit OpenBox(2,itemId);
        }
    }
    
    //消耗diamonds打开盲盒
    function box() public{
        uint256 balance=_diamonds.balanceOf(msg.sender);
        require(balance >= price, "diamonds Not enough");
        _diamonds.transferRole(msg.sender,address(this),price);
        //_diamonds.burn(msg.sender,price);//销毁用户代币
        uint256 r=rand(20,0);
        if(r>=10){
            uint256 itemId=_worker.mintWorker(msg.sender,"");
            emit OpenBox(1,itemId);
        }else{
            uint256 itemId=_hoe.mintHoe(msg.sender,"");
            emit OpenBox(2,itemId);
        }
    }
    
    function rand(uint256 _length,uint256 _nonce) public view returns(uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp,_nonce)));
        return random%_length+1;
    }
}
