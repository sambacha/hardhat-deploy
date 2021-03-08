/// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

abstract contract Proxied {
    /// @notice to be used by initialisation / postUpgrade function so that only the owner can execute them
    /// It also allows these functions to be called inside a contructor when the contract
    /// is meant to be used without proxy
    modifier proxied() {
        address ownerAddress = _owner();
        /** 
        * @dev With hardhat-deploy proxies
        * the ownerAddress is zero only for the implementation contract
        * if the implementation contract want to be used as standalone
        * it simply has to execute the `proxied` function
        */ This ensure the ownerAddress is never zero post deployment
        if (ownerAddress == address(0)) {
            // @note ensure can not be called twice when used outside of proxy : no admin    
          /**
           * @dev Storage slot with the admin of the contract.
           * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
           * validated in the constructor.
           */
            // solhint-disable-next-line security/no-inline-assembly
            assembly {
                sstore(
                    0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103,
                    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                )
            }
        } else {
            require(msg.sender == ownerAddress);
        }
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner(), "NOT_AUTHORIZED");
        _;
    }

    function _owner() internal view returns (address ownerAddress) {
        // solhint-disable-next-line security/no-inline-assembly
        assembly {
            ownerAddress := sload(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103)
        }
    }
}
