pragma solidity ^0.8.11;

import './RWD.sol';
import './Tether.sol';

contract DecentralBank {
    address public owner;
    string public name = 'Decentral Bank';
    string public symbol = 'DB';
    Tether public tether;
    RWD public rwd;

    address [] public stakers;

    mapping (address => uint) public stackingBalance;
    mapping (address => bool) public isStacking;
    mapping (address => bool) public hasStacked;


    constructor(RWD _rwd, Tether _tether) public {
        owner = msg.sender;
        rwd = _rwd;
        tether = _tether;
    }

    // @prams _amount: uint
    // deposit ether to the bank account or to this contract
    function depositTokens(uint _amount) public payable {
        require(_amount > 0,'Amount must be greater than 0'); 
        tether.transferFrom(msg.sender, address(this), _amount);
        stackingBalance[msg.sender] += _amount;

        if(!hasStacked[msg.sender]) {
            stakers.push(msg.sender);
        }

        isStacking[msg.sender] = true;
        hasStacked[msg.sender] = true;
    }


    // issue reward to the staking account
    function issueRewards() public {
        require(msg.sender == owner, 'Only owner can issue rewards');
        for(uint i = 0; i < stakers.length; i++) {
            uint totalStakingBalance = stackingBalance[stakers[i]] / 10;
            if(totalStakingBalance > 0) {
                rwd.transfer(stakers[i], totalStakingBalance);
            }
            

        }
    }

    // unstack tokens from the staking account
    function unstackTokens(uint _amount) public {
        uint Balance = stackingBalance[msg.sender];
        require(Balance > 0,'Amount must be greater than 0'); 
        tether.transfer(msg.sender, Balance);
        stackingBalance[msg.sender] = 0;
        isStacking[msg.sender] = false;
        
    }

}
