pragma solidity 0.8.1;
pragma abicoder v2;
contract walletMultisig {
    
    address[] public owners;
    uint public quorum;
    mapping (address => bool) isOwner;
    uint public contractBal;
    
    
    struct Transaction{
        
        address from;
        address payable to;
        uint amount;
        bool isExecuted;
        //mapping(address => bool) isApprovedd; mapping inside a struct is not allowed in recent solidity versions; have to use double mapping instead.
        uint approveCount;
        uint index;
    }
    
    mapping(uint=> mapping(address=>bool)) isConfirmed;
     
    Transaction[] public transactions;
    
    //mapping (address=>uint) accBalance; 
    
    constructor(address[] memory _owner, uint _minApprovals) {
   
   require(_owner.length >0 && _minApprovals >0 && _minApprovals <= _owner.length, "Invaid inputs detected. pl. submit valid inputs");
   for(uint i=0; i<_owner.length; i++){
       address owner=_owner[i];
       require(owner != address(0), "Invalid address detected. Pl. enter valid address");
       require(!isOwner[owner], "Duplicate owner detected. Owners should be unique");
       isOwner[owner] = true;
       owners.push(owner);
       }
       quorum = _minApprovals;
      }
      
   modifier onlyOwner{
       require(isOwner[msg.sender], "Only owners can transact with me!");
       _;
   }
   
  modifier onlyCreated(uint index){
       require(index < transactions.length, "Transaction not found");
       _;
   }

  modifier onlyNotConfirmed(uint index){
    require(!isConfirmed[index][msg.sender], "You have already confirmed. Request another owner to confirm");
    _;
    
}
   
   
    function deposit() payable external onlyOwner {
        
        contractBal = (address(this).balance);
    } 
    
    function createTransaction(address payable _to, uint _value) public onlyOwner returns(uint) {
        
        require(address(this).balance >= _value, "Insufficient balance");
        uint txindex = transactions.length;
        
       transactions.push(Transaction({
            from: msg.sender, 
            to: _to, 
            amount: _value,
            isExecuted: false, 
           // isApprovedd: false, 
            approveCount: 1, 
            index: txindex 
            }));
        isConfirmed[txindex][msg.sender] = true;
        return(txindex);//can emit an event here
    }
    
    function approveTransaction(uint _txindex) public onlyOwner onlyCreated(_txindex) onlyNotConfirmed(_txindex) returns(string memory){
        
        Transaction storage transaction = transactions[_txindex];
        transaction.approveCount +=1;
        isConfirmed[_txindex][msg.sender] = true;
        
        if(transaction.approveCount >= quorum){
           transaction.isExecuted = true;
           transaction.to.transfer(transaction.amount);
           
           return("Successfully transferred");//instead can use emit to notify all the stakeholders
            
        }
        
    }
    
  
}    
