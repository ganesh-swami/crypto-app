pragma solidity ^0.8.11;

contract Migrations {
    address public owner;
    uint public last_completed_migration=0;

    event Logging (string text, address data);
    event Loggingint (string text, uint data);

    constructor() public{
        // console.log(" constructor msg.sender", msg.sender);
        emit Logging (" constructor msg.sender", msg.sender);
        owner = msg.sender;
        //last_completed_migration = 0;
    }

    modifier onlyOwner {
        if (msg.sender != owner)
        _;
    }

    function setCompleted(uint completed) public onlyOwner {
        emit Loggingint("completed", completed);
        last_completed_migration = completed;
    }
    
    function upgrade(address new_address) public onlyOwner {
        emit Logging("new address", new_address);
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration+1);
        emit Loggingint("last_completed_migration", last_completed_migration);
        
    }
}
