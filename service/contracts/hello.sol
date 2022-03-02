// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Hello{

    string content;

    event Over(string content);

    function getContent()public view returns(string memory){
        return content;
    }
    
    function setContent(string memory text)public{
        content=text;
        emit Over(content);
    }

}
