
pragma solidity ^0.4.19;

contract CampaignRegistry is Ownable {
  /* address[] private payees;
  address [] private contributors;
  address [] private campaignID; */

  mapping (address => bool) payeeMap;
  mapping (address => bool) contributorMap;
  mapping (address => bool) campaignMap;
  mapping (address => bool) candidateMap;

  event PayeeAdded(address payee)
  event contributorAdded(address contributor)
  event CampaignAdded(address campaign)
  event CandidateAdded(address candidate)



  function addPayee(address _payee) Ownable {
    payeeMap[_payee]=true;
    PayeeAdded(_payee)
  }

  function addContributor(address _contributor) Ownable{
    contributorMap[_contributor] =true;
    contributorAdded(_contributor)
  }

  function addCampaignID(address _campaignID, address _creater) public{
    require(candidateMap[_creater]==true);
    campaignMap[_campaignID]=true;
    CampaignAdded(_campaign)
  }

  function isPayee() Ownable returns (bool){
    return (payeeMap[_payee]);
  }

  function isContributor() Ownable returns (bool){
    return(contributorMap[_contributor]);
  }

  function addCandidate(address _candidate) Ownable {
    candidateMap[_candidate]=true;
    CandidateAdded(_candidate);
  }



}
