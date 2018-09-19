pragma solidity ^0.4.22;

contract ServerConfig {
    mapping (bytes32 => string) serverConfig;
    
    // constructor
    constructor () public {
        serverConfig["WEB_PAY_URL"] = "payx://webpay/";
    }
    
    // modifier
    address owner;
    modifier onlyOwner {
        if (msg.sender != owner) {
            return;
        }
        _;
    }
    
    function getServerConfig(bytes32 key) public view returns (string) {
        return serverConfig[key];
    }
    
    // destructor
    function kill() onlyOwner public {
        selfdestruct(this);
    }
}
