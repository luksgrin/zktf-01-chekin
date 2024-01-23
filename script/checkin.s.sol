// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {CheckIn} from "src/zkCTF-sample1/checkin.sol";

contract CheckInScript is Script {

    CheckIn checkin;

    function setUp() public {}

    function run() public returns (address){
        vm.broadcast();
        checkin = new CheckIn();
        return address(checkin);
    }
}
