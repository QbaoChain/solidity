pragma solidity ^0.4.22;

contract ServerConfigFunction {
    string[] keyStringArr;
    mapping (string => string) serverConfigMap;
    
    // constructor
    constructor () public {
        owner = msg.sender;
        
        keyStringArr.push("WEB_PAY_URL");
        serverConfigMap["WEB_PAY_URL"] = "payx://webpay/";
    }
    
    // modifier
    address owner;
    modifier onlyOwner {
        if (msg.sender != owner) {
            return;
        }
        _;
    }
    
    // get config by key
    function getServerConfig(string key) public view returns (string) {
        if (compareString(key,"")) {
            return getAllServerConfig();
        }
        else {
            return serverConfigMap[key];
        }
    }
    
    // get all config
    function getAllServerConfig() internal view returns (string) {
        if (keyStringArr.length == 0) {
            return "";
        }
        
        string memory ret = "{";
        
        for (uint256 i=0; i<keyStringArr.length; ++i) {
            string memory key = keyStringArr[i];
            string memory value = serverConfigMap[key];
            
            ret = addString(ret, '"');
            ret = addString(ret, key);
            ret = addString(ret, '"');
            ret = addString(ret, ":");
            ret = addString(ret, '"');
            ret = addString(ret, value);
            ret = addString(ret, '"');
            
            if (i+1 != keyStringArr.length) {
                ret = addString(ret, ",");
            }
            else {
                ret = addString(ret, "}");
            }
        }
        
        return ret;
    }
    
    // set config
    function setServerConfig(string key, string value) public payable {
        serverConfigMap[key] = value;
        
        bool isExist = false;
        
        for (uint256 i=0; i<keyStringArr.length; ++i) {
            if (compareString(keyStringArr[i], key)) {
                isExist = true;
                break;
            }
        }
        
        if (!isExist) {
            keyStringArr.push(key);
        }
    }
    
    // compare string equality
    function compareString(string a, string  b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
    
    // string + string
    function addString(string a, string b) internal pure returns (string) {
        bytes memory _ba = bytes(a);
        bytes memory _bb = bytes(b);
        string memory retb = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(retb);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bret[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(bret);
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
    
    // set address & param
    function setContractAddress(string add) onlyOwner public payable {
        contractAddress = add;
    }
    
    function setParamGetServerConfig(string param) onlyOwner public payable {
        paramGetServerConfig = param;
    }
    
    function setParamSetServerConfig(string param) onlyOwner public payable {
        paramSetServerConfig = param;
    }
    
    // get address & param
    function getAddressAndParam() public view returns (string add, 
    string paramGet, string paramSet) {
        return(contractAddress, paramGetServerConfig, paramSetServerConfig);
    }
    
    // destructor
    function kill() onlyOwner public {
        selfdestruct(this);
    }
}
