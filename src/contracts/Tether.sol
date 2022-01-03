pragma solidity ^0.8.11;

contract Tether {
    string public name= 'Tether';
    string public symbol = 'USDT';
    uint256 public decimals = 18;
    uint256 public totalSupply = 1000000000000000000000000;


    event Transfer(
        address indexed _from,
        address indexed _to,
        uint _value
    );

    event Approve(
        address indexed _owner,
        address indexed _spender,
        uint _value
    );

    mapping(address => uint256) public balanceOf;
    mapping( address => mapping(address => uint256)) public allowance;

    constructor() public{
        balanceOf[msg.sender]=totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        require(_to!=address(0));
        require(_value>0);
        require(balanceOf[msg.sender]>=_value);

        balanceOf[msg.sender]-=_value;
        balanceOf[_to]+=_value;
        emit Transfer(msg.sender,_to,_value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        require(_value>0);
        allowance[msg.sender][_spender]=_value;
        emit Approve(msg.sender,_spender,_value);
        return true;
    }
    function transferFrom(address _from,address _to, uint256 _value) public returns (bool success){
        require(_from!=address(0));
        require(_to!=address(0));
        require(_value>0);
        require(balanceOf[_from]>=_value);
        require(allowance[_from][msg.sender]>=_value);
        balanceOf[_from]-=_value;
        balanceOf[_to]+=_value;
        emit Transfer(_from,_to,_value);
        return true;
    }




}