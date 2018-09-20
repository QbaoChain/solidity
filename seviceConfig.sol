pragma solidity ^0.4.22;

contract ServerConfigFunction {
    string[] public keyStringArr;
    mapping (string => string) serverConfigMap;
    
    string ret;
    
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
    
    // get
    function getServerConfig(string key) public view returns (string) {
        if (compareString(key,"")) {
            return getAllServerConfig();
        }
        else {
            return serverConfigMap[key];
        }
    }
    
    // get all
    function getAllServerConfig() internal view  returns (string) {
        if (keyStringArr.length == 0) {
            return "";
        }
        
        ret = "{";
        
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
        }
        
        ret = addString(ret, "}");
        
        
        return ret;
    }
    
    // set
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
    
    function compareString(string a, string  b) internal pure returns (bool) {
        return keccak256(a) == keccak256(b);
    }
    
    function addString(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory retb = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(retb);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
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
