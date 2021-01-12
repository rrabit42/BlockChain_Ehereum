pragma solidity 0.5.16;

contract Election {
  // Model a Candidate
    struct Candidate {
    uint id;
    string name;
    uint voteCount;
  }

  // Read, Write Candidates
  mapping(uint => Candidate) public candidates;

  // Store Candidates Count
  uint public candidatesCount;

  // Store accounts that have voted
  mapping(address => bool) public voters;

  function addCandidate(string memory _name) private {
    candidatesCount++;
    candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
  }

  function vote(uint _candidateId) public {
    // require that they haven't voted before
    require(!voters[msg.sender], "This Voter has already voted!");

    // require a valid candidate
    require(_candidateId > 0 && _candidateId <= candidatesCount, "There is no such candidate");

    // record that voter has voted
    voters[msg.sender] = true;

    // update candidate vote Count
    candidates[_candidateId].voteCount++;
  }

  constructor() public {
    addCandidate("Candidate 1");
    addCandidate("Candidate 2");
  }
}
