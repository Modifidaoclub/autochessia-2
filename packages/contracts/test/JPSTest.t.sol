// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import { JPS, PriorityQueue, NewPQ } from "../src/library/JPS.sol";

contract JPSTest is Test {
    uint256[][] field;

    function setUp() public {
        uint256[][] memory input = new uint256[][](5);
        input[0] = new uint256[](5);
        input[1] = new uint256[](5);
        input[2] = new uint256[](5);
        input[2][0] = 1;
        input[2][1] = 1;
        input[2][2] = 1;
        input[2][3] = 1;
        input[3] = new uint256[](5);
        input[4] = new uint256[](5);
        field = JPS.generateField(input);
    }

    function test_PQ() public {
        PriorityQueue memory pq = NewPQ(5);
        pq.AddTask(1,1);
        pq.AddTask(2,2);
        pq.AddTask(3,30);
        pq.AddTask(4,4);
        pq.AddTask(5,5);
        for (uint i; i < 5; ++i) {
            console.log("Pop task, data %d", pq.PopTask());
        }
    }

    function test_FieldIsGood() public {
        uint256[][] memory input = new uint256[][](3);
        input[0] = new uint256[](3);
        input[1] = new uint256[](3);
        input[1][1] = 1;
        input[2] = new uint256[](3);
        printInput(input);
        field = JPS.generateField(input);
        // check boundary
        assertFalse(JPS.fieldNotObstacle(field, JPS.composeData(0, 3)));
        assertFalse(JPS.fieldNotObstacle(field, JPS.composeData(4, 3)));
        assertFalse(JPS.fieldNotObstacle(field, JPS.composeData(3, 0)));
        assertFalse(JPS.fieldNotObstacle(field, JPS.composeData(3, 4)));
        // check the leftmost and lowest coordinate
        assertTrue(JPS.fieldNotObstacle(field, JPS.composeData(1, 1)));
        // check the central obstacle
        assertFalse(JPS.fieldNotObstacle(field, JPS.composeData(2, 2)));
    }

    function test_FindPath() public {
        uint256 start = JPS.composeData(1, 1);
        uint256 end = JPS.composeData(5, 1);
        uint256[] memory path = JPS.findPath(field, start, end);
        for (uint i; i < path.length; ++i) {
            (uint x, uint y) = JPS.decomposeData(path[i]);
            console.log("(%d,%d)", x, y);
        }
    }

    function printInput(uint256[][] memory _input) private view {
        for (uint i; i < 3; ++i) {
            console.log(" %d  %d  %d ", _input[0][2-i], _input[1][2-i], _input[2][2-i]);
        }
    } 
}