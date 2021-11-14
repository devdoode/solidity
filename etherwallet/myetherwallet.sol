// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EtherWallet {
  address payable public owner;
  mapping (address => uint ) public bal;

  constructor(address payable _owner)  {
    owner = _owner;
  }

  function deposit() payable public { 
      bal[msg.sender] += msg.value;
      
  }

  function send(address payable to, uint amount) public {
   // if(msg.sender == owner) { //modifier can also be used. require can also be used.
      
      if(amount <= bal[to]){
      to.transfer(amount);
      return;
   //   }
    } 
    revert('sender is not allowed. Only admin can rug pull!');
  }

  function balanceOf() view public returns(uint) {
    return address(this).balance;
  }
}
