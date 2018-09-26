pragma solidity ^0.4.22;

import "github.com/turanturan/solidityTool/ToolsFunction.sol";

contract ServerConfigFunction is ToolsFunction {
    string[] keyStringArr;
    mapping (string => string) serverConfigMap;
    
    // init data
    function initData() internal {
        keyStringArr.push("WEB_PAY_URL");
        serverConfigMap["WEB_PAY_URL"] = "payx://webpay/";
    }
    
    /* external function */
    // get config
    function getServerConfig(string key) external constant returns (string) {
        // get all config
        if (compareString(key,"")) {
            return getAllServerConfig();
        }
        // get config by key
        else {
            return serverConfigMap[key];
        }
    }
    
    // set config
    function setServerConfig(string key, string value) external payable {
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
    
    // del config
    function deleteServerConfig(string key) external payable {
        bool isExist = false;
        
        for (uint256 i=0; i<keyStringArr.length; ++i) {
            if (compareString(keyStringArr[i], key)) {
                isExist = true;
                break;
            }
        }
        
        if (isExist) {
            deleteByIndex(keyStringArr, i);
            delete serverConfigMap[key];
        }
    }
    
    /* private function */
    // get all config
    function getAllServerConfig() private constant returns (string) {
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
}

contract ServerConfigManager is ToolsFunction {
    string public contractAddress;
    
    // init data
    function initData() internal {
        
    }
    
    /* onlyOwner function */
    // set address
    function setContractAddress(string add) onlyOwner external payable {
        contractAddress = add;
    }
    
    /* external function */
    // set function
    function setServerConfig(string key, string value) external payable {
        ServerConfigFunction contractFunction = 
        ServerConfigFunction(bytesToAddress(bytes(contractAddress)));
        
        contractFunction.setServerConfig.value(msg.value)(key, value);
    }
    
    // del function
    function deleteServerConfig(string key) external payable {
        ServerConfigFunction contractFunction = 
        ServerConfigFunction(bytesToAddress(bytes(contractAddress)));
        
        contractFunction.deleteServerConfig.value(msg.value)(key);
    }
}
