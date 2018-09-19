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
    string contractAddress;
    string paramGetServerConfig;
    string paramSetServerConfig;
    
    // constructor
    constructor () public {
        owner = msg.sender;
        
        // will delete
        // contractAddress = "2c406a57f2c12ad1c3b262a5acc9d0333dc803f8";
        // paramGetServerConfig = "93eb57e1";
        // paramSetServerConfig = "abcdefgh";
        
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
    function setParamGetServerConfig(string param) onlyOwner public {
        paramGetServerConfig = param;
    }
    
    function setParamSetServerConfig(string param) onlyOwner public {
        paramSetServerConfig = param;
    }
    
    function setContractAddress(string add) onlyOwner public {
        contractAddress = add;
    }
    
    // get
    function getAddressAndParam() public view returns (string add, 
    string paramGet, string paramSet) {
        return(contractAddress, paramGetServerConfig, paramSetServerConfig);
    }
    
    // destructor
    function kill() onlyOwner public {
        selfdestruct(this);
    }
}
