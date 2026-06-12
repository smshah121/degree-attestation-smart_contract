// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DegreeAttestation {

    struct Degree {
        string studentId;
        string hash;       
        uint256 timestamp;
        bool exists;
    }

    address public owner;
    mapping(string => Degree) public degrees;

    event DegreeStored(
        string studentId,
        string hash,
        uint256 timestamp
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only admin can add");
        _;
    }

   
    function storeDegree(
        string memory _studentId,
        string memory _hash
    ) public onlyOwner {
        require(!degrees[_studentId].exists, "Degree already exists");

        degrees[_studentId] = Degree(
            _studentId,
            _hash,
            block.timestamp,
            true
        );

        emit DegreeStored(_studentId, _hash, block.timestamp);
    }

    function verifyDegree(
        string memory _studentId
    ) public view returns (bool) {
        return degrees[_studentId].exists;
    }

   
    function getDegree(
        string memory _studentId
    ) public view returns (
        string memory studentId,
        string memory hash,
        uint256 timestamp
    ) {
        require(degrees[_studentId].exists, "Degree not found");
        Degree memory d = degrees[_studentId];
        return (d.studentId, d.hash, d.timestamp);
    }
}