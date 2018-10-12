pragma solidity ^0.4.22;

import "github.com/turanturan/solidityTool/ToolsFunction.sol";

contract ServerConfigFunction is ToolsFunction {
    string[] keyStringArr;
    mapping (string => string) serverConfigMap;
    
    event SetServerConfig(string key, string value);
    event DeleteServerConfig(string key);
    
    // init data
    function initData() internal {
        keyStringArr.push("WEB_PAY_URL");
        serverConfigMap["WEB_PAY_URL"] = "payx://webpay/";
    }
    
    /* external function */
    // get config
    function getServerConfig(string key) external view returns (string) {
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
    function setServerConfig(string key, string value) external {
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
        
        emit SetServerConfig(key, value);
    }
    
    // del config
    function deleteServerConfig(string key) external {
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
            emit DeleteServerConfig(key);
        }
    }
    
    /* private function */
    // get all config
    function getAllServerConfig() private view returns (string) {
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
    ServerConfigFunction contractFunction;
    
    event SetContractAddress(string add);
    event SetServerConfig(string key, string value);
    event DeleteServerConfig(string key);
    
    // init data
    function initData() internal {
        
    }
    
    /* onlyOwner function */
    // set address
    function setContractAddress(string add) onlyOwner external {
        contractAddress = add;
        contractFunction = ServerConfigFunction(bytesToAddress(bytes(contractAddress)));
        emit SetContractAddress(add);
    }
    
    /* external function */
    // set function
    function setServerConfig(string key, string value) external {
        contractFunction.setServerConfig(key, value);
        emit SetServerConfig(key, value);
    }
    
    // del function
    function deleteServerConfig(string key) external {
        contractFunction.deleteServerConfig(key);
        emit DeleteServerConfig(key);
    }
}
