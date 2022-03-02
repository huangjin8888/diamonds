// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./util/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./util/contracts/utils/Counters.sol";
import "./util/contracts/access/AccessControl.sol";

contract Worker is AccessControl,ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct Prop{
        uint16 power;        //力量
        uint256[] digTime;//记录挖矿时间戳
    }
    
    mapping(uint=>Prop) public props;

    constructor() ERC721("Worker", "WOR") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function tokenIds() public view returns(uint256){
        return _tokenIds.current();
    }

    function mintWorker(address player, string memory tokenURI)public onlyRole(MINTER_ROLE) returns(uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        Prop memory i;
        i.power=uint16(rand(100,0));
        props[newItemId]=i;
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    function setTokenUri(uint256 _tokenId,string memory tokenURI)public onlyRole(MINTER_ROLE){
        _setTokenURI(_tokenId, tokenURI);
    }

    function setRole(address addr) public onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(MINTER_ROLE,addr);
    }

    function setMoveNft(address owner,address addr,bool b) public onlyRole(MINTER_ROLE){
        _setApprovalForAll(owner,addr,b);//允许市场合约转移NFT
    }
    
    function supportsInterface(bytes4 interfaceId)public view override(ERC721, AccessControl)returns (bool){
        return super.supportsInterface(interfaceId);
    }

    function getByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](balanceOf(_owner));
        uint counter = 0;
        for (uint i = 1; i <= _tokenIds.current(); i++) {
            if (ownerOf(i) == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    //挖矿操作
    function dig(address player,uint256 tokenId) public{
        require(ownerOf(tokenId)==player,"player and token not matched");
        require(digAlow(tokenId),"dig count not enough");
        props[tokenId].digTime.push(block.timestamp);//记录参赛时间戳
    }

    //检查是否可以挖矿
    function digAlow(uint256 _tokenId) public view returns(bool){
        //判断当前token24小时内是否挖矿了，超过则不允许挖矿
        uint256 start=block.timestamp-86400;
        uint256 end=block.timestamp;
        uint counter=0;
        for(uint256 i=0;i<props[_tokenId].digTime.length;i++){
            if(props[_tokenId].digTime[i]>start&&props[_tokenId].digTime[i]<end){
                counter++;
            }
        }
        if(counter>=1){
            return false;
        }
        return true;
    }
    
    function rand(uint256 _length,uint256 _nonce) public view returns(uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp,_nonce)));
        return random%_length+1;
    }
}
