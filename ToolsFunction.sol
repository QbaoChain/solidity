pragma solidity >=0.4.0;

contract ToolsFunction {
    // modifier
    address owner;
    modifier onlyOwner {
        if (msg.sender != owner) {
            return;
        }
        _;
    }
    
    // constructor
    constructor () public {
        owner = msg.sender;
        
        initData();
    }
    
    // destructor
    function destructor() onlyOwner public {
        selfdestruct(this);
    }
    
    // init
    function initData() internal;
    
    // bytes32 to bytes
    function bytes32ToBytes(bytes32 by) internal pure returns (bytes) {
        bytes memory ret = new bytes(by.length);
        
        for(uint i = 0; i < by.length; i++) {
            ret[i] = by[i];
        }
        
        return ret;
    }
    
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
    
    // compare string equality
    function compareString(string a, string  b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
    
    // compare bytes32 equality
    function compareBytes(bytes32 a, bytes32 b) internal pure returns (bool) {
        return keccak256(bytes32ToBytes(a)) == keccak256(bytes32ToBytes(b));
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
   
    // delete int arr by index
    function deleteByIndex(uint256[] storage intArr, uint256 index) internal {
        uint256 len = intArr.length;
        
        if (index >= len) {
            return;
        }
        
        for (uint256 i = index; i<len-1; ++i) {
            intArr[i] = intArr[i+1];
        }
        
        delete intArr[len-1];
        intArr.length--;
    }
    
    // delete bytes32 arr by index
    function deleteByIndex(bytes32[] storage bytes32Arr, uint256 index) internal {
        uint256 len = bytes32Arr.length;
        
        if (index >= len) {
            return;
        }
        
        for (uint256 i = index; i<len-1; ++i) {
            bytes32Arr[i] = bytes32Arr[i+1];
        }
        
        delete bytes32Arr[len-1];
        bytes32Arr.length--;
    }
    
    // delete str arr by index
    function deleteByIndex(string[] storage strArr, uint256 index) internal {
        uint256 len = strArr.length;
        
        if (index >= len) {
            return;
        }
        
        for (uint256 i = index; i<len-1; ++i) {
            strArr[i] = strArr[i+1];
        }
        
        delete strArr[len-1];
        strArr.length--;
    }
}