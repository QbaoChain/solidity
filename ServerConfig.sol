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
    
    // get config
    function getServerConfig(string key) public view returns (string) {
        if (compareString(key,"")) {
            return getAllServerConfig();
        }
        else {
            return serverConfigMap[key];
        }
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
    
    // private
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
        
        for (uint i=0; i<_ba.length; ++i) {
            bret[k++] = _ba[i];
        }
        
        for (i=0; i<_bb.length; ++i) {
            bret[k++] = _bb[i];
        }
        
        return string(bret);
   }
    
    // destructor
    function destructor() onlyOwner public {
        selfdestruct(this);
    }
}

contract ServerConfigManager {
    string contractAddress;
    string paramGetServerConfig;
    
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
    
    // set address & param(get)
    function setContractAddress(string add) onlyOwner public payable {
        contractAddress = add;
    }
    
    function setParamGetServerConfig(string param) onlyOwner public payable {
        paramGetServerConfig = param;
    }
    
    // get address & param
    function getAddressAndParam() public view returns (string, string) {
        return(contractAddress, paramGetServerConfig);
    }
    
    // set function
    function setServerConfig(string key, string value) public payable {
        ServerConfigFunction contractFunction = 
        ServerConfigFunction(bytesToAddress(bytes(contractAddress)));
        
        contractFunction.setServerConfig.value(msg.value)(key, value);
    }
    
    // private
    // bytes to address
    function bytesToAddress (bytes b) internal pure returns (address) {
        uint result = 0;
        
        for (uint i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            
            if (c >= 48 && c <= 57) {
                result = result * 16 + (c - 48);
            }
            
            if (c >= 65 && c<= 90) {
                result = result * 16 + (c - 55);
            }
            
            if (c >= 97 && c<= 122) {
                result = result * 16 + (c - 87);
            }
        }
        
        return address(result);
    }
    
    // destructor
    function destructor() onlyOwner public {
        selfdestruct(this);
    }
}
