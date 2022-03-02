// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Test {
    uint8 public val1;
    uint16 public val2;
    uint32 public val3;
    uint64 public val4;
    uint128 public val5;
    uint256 public val6;
    function setVal1(uint8 _val)public{
        val1=_val;
    }
    function setVal2(uint16 _val)public{
        val2=_val;
    }
    function setVal3(uint32 _val)public{
        val3=_val;
    }
    function setVal4(uint64 _val)public{
        val4=_val;
    }
    function setVal5(uint128 _val)public{
        val5=_val;
    }
    function setVal6(uint256 _val)public{
        val6=_val;
    }
}