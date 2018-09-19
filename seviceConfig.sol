pragma solidity ^0.4.22;

contract ServerConfigFunction {
    mapping (string => string) serverConfig;
    
    // constructor
    constructor () public {
        owner = msg.sender;
        
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
    
    // get
    function getServerConfig(string key) public view returns (string) {
        return serverConfig[key];
    }
    
    // set
    function setServerConfig(string key, string value) public payable {
        serverConfig[key] = value;
    }
    
    // destructor
    function kill() onlyOwner public {
        selfdestruct(this);
    }
}

contract ServerConfigManager {
    string public paramGetServerConfig;
    string public paramSetServerConfig;
    string public contractAddress;
    
    // constructor
    constructor () public {
        owner = msg.sender;
    }
    
    // modifier
    address owner;
    modifier onlyOwner {
        if (msg.sender != owner) {
            return;
        }
        _;
    }
    
    // set
    function setParamGetServerConfig(string param) onlyOwner public
    {
        paramGetServerConfig = param;
    }
    
    function setParamSetServerConfig(string param) onlyOwner public
    {
        paramSetServerConfig = param;
    }
    
    function setContractAddress(string add) onlyOwner public
    {
        contractAddress = add;
    }
    
    // destructor
    function kill() onlyOwner public {
        selfdestruct(this);
    }
}
