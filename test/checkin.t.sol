// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {CheckIn} from "src/zkCTF-sample1/checkin.sol";

contract CheckInTest is Test {

    CheckIn checkin;
    string root = vm.projectRoot();

    function setUp() public {
        checkin = new CheckIn();
    }

    /**
     * Load the proof from the formatted_calldata.json file
     */
    function load_proof() internal view returns(
        uint256[24] memory proof,
        uint256[1] memory pubSignals
    ) {

        // Path for the formatted_calldata.json file
        string memory _proof_json = vm.readFile(
            string.concat(root, "/test/formatted_calldata.json")
        );

        // Initialize the proof and pubSignals dynarrays
        uint256[] memory _proof = new uint256[](24);
        uint256[] memory _pubSignals = new uint256[](1);

        // Parse the proof and pubSignals from the JSON file
        _proof = vm.parseJsonUintArray(_proof_json, ".proof");
        _pubSignals = vm.parseJsonUintArray(_proof_json, ".pubSignals");

        // Copy the proof and pubSignals from the memory arrays to the statically sized arrays
        for (uint256 i; i < 24; i++) {
            proof[i] = _proof[i];
        }
        for (uint256 i; i < 1; i++) {
            pubSignals[i] = _pubSignals[i];
        }

    }

    /**
     * Test a valid proof
     */
    function test_proof_pass() public {
        uint256[24] memory proof;
        uint256[1] memory pubSignals;
        (proof, pubSignals) = load_proof();

        checkin.verify(proof, pubSignals);

        assertTrue(
            checkin.isSolved()
        );
    }

    /**
     * Test an invalid proof
     */
    function test_proof_fail() public {
        uint256[24] memory proof;
        uint256[1] memory pubSignals;
        (proof, pubSignals) = load_proof();

        // Tamper the proof lol
        proof[0] = 0;

        checkin.verify(proof, pubSignals);

        assertFalse(
            checkin.isSolved()
        );
    }
}
