pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './interfaces/ERC223_receiving_contract.sol';

contract CampaignFund is Ownable, ERC223ReceivingContract {

    using SafeMath for uint256;

    mapping(address => uint8) private _owners;


    struct Transaction {
      address from;
      address to;
      uint amount;
      uint8 signatureCount;
      mapping (address => uint8) signatures;
    }

    mapping (uint => Transaction) private _transactions;
    uint[] private _pendingTransactions;


    uint private transactionIdx;
    uint constant MIN_SIGNATURES = 10;
    address tokenAddress;
    uint maxDonation;
    CampaignRegistry Registry;

    mapping (address => uint) ContributionTracker;

    event ownerAdded(address newOwner);
    event ownerRemoved(address deletedOwner);

    event Contribution(address contributor, address reciever, uint amount, uint timestamp);

    event transactionCreated(address campagin, address reciever, uint amount, uint timestamp);
    event TransactionCompleted(address from, address to, uint amount, uint transactionId, uint timestamp);
    event TransactionSigned(address by, uint transactionId);

    modifier validOwner() {
        require(msg.sender == _owner || _owners[msg.sender] == 1);
        _;
    }


    function CampaignFund( uint _maxDonation ) public {
        Registry= CampaignRegistry(0xabc);
        tokenAddress = 0x123;
        Registry.addCampaignID(this,msg.sender);
        maxDonation= _maxDonation;
    }

    function addOwner(address _owner)
      onlyOwner
      public {
        _owners[owner] = 1;
        ownerAdded(_owner);
      }

    function removeOwner(address owner)
      onlyOwner
      public {
        _owners[owner] = 0;
        ownerRemoved(_owner);
      }


    function contribute(uint _amount) public {
        require (ContributionTracker[msg.sender]+_amount <= maxDonation );
        require(Registry.isContributor(msg.sender));
        require(ERC20(tokenAddress).transferFrom(msg.sender, this, _amount));
        ContributionTracker[msg.sender]+= _amount;

    }

    function tokenFallback(address _from, uint _value, bytes _data) public {
        require(Registry.isContributor(_from));
        require(ContributionTracker[_from] + _value <= maxDonation);
        Contribution(_from, this, _value, now);
    }


    function getFundBalance() public constant returns(uint256) {
        return (ERC20(tokenAddress).balanceOf(this));
    }



    /**********
     Standard kill() function to recover funds
     **********/
    function kill() external {
        if (msg.sender == creator) {
            selfdestruct(creator);
        }
    }

}
