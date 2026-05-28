// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Certificate {

    struct Cert {
        string studentName;
        string course;
        string certId;
        bool exists;
        uint256 timestamp;   // ← when certificate was added
        bytes32 hash;        // ← hash of certificate data
    }

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(string => Cert) public certificates;

    function addCertificate(
        string memory _certId,
        string memory _studentName,
        string memory _course
    ) public {
        require(msg.sender == owner, "Only admin can add");

        // generate hash from certId + studentName + course combined
        bytes32 certHash = keccak256(
            abi.encodePacked(_certId, _studentName, _course)
        );

        // block.timestamp = current time in seconds (unix timestamp)
        uint256 certTimestamp = block.timestamp;

        certificates[_certId] = Cert(
            _studentName,
            _course,
            _certId,
            true,
            certTimestamp,  // ← store timestamp
            certHash        // ← store hash
        );
    }

    function verifyCertificate(string memory _certId)
        public
        view
        returns (bool)
    {
        return certificates[_certId].exists;
    }

    // ← new function to get full certificate details including hash and timestamp
    function getCertificate(string memory _certId)
        public
        view
        returns (
            string memory studentName,
            string memory course,
            string memory certId,
            uint256 timestamp,
            bytes32 hash
        )
    {
        require(certificates[_certId].exists, "Certificate not found");

        Cert memory cert = certificates[_certId];

        return (
            cert.studentName,
            cert.course,
            cert.certId,
            cert.timestamp,
            cert.hash
        );
    }
}