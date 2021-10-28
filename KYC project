pragma solidity ^0.5.3;

contract smartkyc
{
   
   
   struct Customerinfo
   {
       string cname;
       string dataHash;
       address bank;
       uint upvotes;
       string password;
   }
   
   struct Org
   {
       string bname;
       address baddress;
       uint kycCount;
       //string regNumber;
       bool blocked;
       uint downvotes;
       
   }
   
   struct Request
   {
       string cname;
       address baddress;
   }
   
   Customerinfo[] public allCustomers;
   
   Org[] public allOrgs;
   
   Request[] public allRequests;
   
   Request[] public validKYCs;
   
   address adminAddress;
   
   constructor() public
   {
       adminAddress = msg.sender;
   }
   
   function addCustomer(string memory _cname, string memory _dataHash) public returns(uint)
   {
       for(uint i=0; i<allCustomers.length; i++)
       {
           if(stringsEqual(allCustomers[i].cname, _cname))
           return 2;                                                                       //2 means user already exist
       }
       allCustomers.length++;
       allCustomers[allCustomers.length-1] = Customerinfo(_cname, _dataHash, msg.sender, 0, "null");
       return 0;                                                                            // 0 means success ie customer added
   }
   
   
   function removeCustomer(string memory _cname) public returns(uint)
   {
        for(uint i=0; i<allCustomers.length; i++)
       {
           if(stringsEqual(allCustomers[i].cname, _cname))
            {
                for(uint j = i+1;j < allCustomers.length; j++)
                {
                allCustomers[i-1] = allCustomers[i];
                }
                allCustomers.length --;
                return 0;
            }
        }
            // throw error if uname not found
        return 1;
    }
           
   function modifyCustomer(string memory _cname, string memory _dataHash) public returns(uint)
   {
        for(uint i = 0; i < allCustomers.length; ++ i)
        {
            if(stringsEqual(allCustomers[i].cname, _cname))
            {
                allCustomers[i].dataHash = _dataHash;
                allCustomers[i].bank = msg.sender;
                return 0;
            }
        }
        // throw error if uname not found
    return 1;
    }  
   
   function viewCustomer(string memory _cname) public view returns(string memory)
   {
        for(uint i = 0; i < allCustomers.length; ++ i)
        {
            if(stringsEqual(allCustomers[i].cname, _cname))
            {
                return allCustomers[i].dataHash;
            }
        }
    return "Customer not found in database!";
   }
   
   function addRequest(string memory _cname, address _baddress) public
   
    {
        for (uint j=0; j<allOrgs.length; j++)
       {
           if(allOrgs[j].blocked == true)
           {
               revert("Sorry, this bank is blocked. Please contact Admin");
           }
       }
       
       
        for(uint i = 0; i < allRequests.length; ++ i)
        {
           if(stringsEqual(allRequests[i].cname, _cname) && allRequests[i].baddress == _baddress)
           {
                return;
           }
        }
       
        allRequests.length ++;
        allRequests[allRequests.length - 1] = Request(_cname, _baddress);
       
    }
   
   
   function removeRequest(string memory _cname) public returns(uint)
   {
     
     for(uint i = 0; i < allRequests.length; ++ i)
     {
        if(stringsEqual(allRequests[i].cname, _cname))
        {
            for(uint j = i+1;j < allRequests.length; j++)
            {
            allRequests[i-1] = allRequests[i];
            }
            allRequests.length --;
            return 0;  //if successful
        }
    }
    return 1;  //if failed
   }
   
   function addBank(string memory _bname, address _baddress) public
   {
       require(msg.sender == adminAddress, "Sorry! Only admin can add a bank");
       for (uint i=0; i<allOrgs.length; i++)
       {
           if(allOrgs[i].baddress == _baddress)
           {
              revert("Bank is already present in the list.");
           }
           
       }
       allOrgs.push(Org(_bname, _baddress, 0, false, 0));
       
   }
   
   function removeBank(address _baddress) public
   {
       require(msg.sender == adminAddress, "Sorry! Only admin can remove a bank");
       
       for (uint i=0; i<allOrgs.length; i++)
       {
           if(allOrgs[i].baddress == _baddress)
           {
              delete allOrgs[i];
           }
       }
   }
   
   function blockBank(address _baddress) public
   {
       require(msg.sender == adminAddress, "Sorry! Only admin can block a bank");
       for (uint i=0; i<allOrgs.length; i++)
       {
           if(allOrgs[i].baddress == _baddress)
           {
               allOrgs[i].blocked = true;
           }
       }
       //revert("Sorry, no such bank found.");
   }
   
    function unblockBank(address _baddress) public
   {
       require(msg.sender == adminAddress, "Sorry! Only admin can block a bank");
       for (uint i=0; i<allOrgs.length; i++)
       {
           if(allOrgs[i].baddress == _baddress)
           {
               allOrgs[i].blocked = false;
           }
       }
       //revert("Sorry, no such bank found.");
   }
   
   function addKYC(string memory _cname, address _baddress) internal  
   {
        for(uint i = 0; i < validKYCs.length; ++ i)
        {
            if(stringsEqual(validKYCs[i].cname, _cname) && validKYCs[i].baddress == _baddress)
            {
                return;
            }
        }
        validKYCs.length ++;
        validKYCs[validKYCs.length - 1] = Request(_cname, _baddress);
    }
   

   function removeKYC(string memory _cname) internal returns(uint)
   {
        for(uint i = 0; i < validKYCs.length; ++ i)
        {
            if(stringsEqual(validKYCs[i].cname, _cname))
            {
            for(uint j = i+1;j < validKYCs.length; ++ j)
            {
            validKYCs[i-1] = validKYCs[i];
            }
            validKYCs.length --;
            return 0;   // if successful
             }
        }
           
        return 1;   //if failed
   }
     
    function updateKYCVotes(string memory _cname, bool ifIncrease) public payable returns(uint)
    {
        for(uint i = 0; i < allCustomers.length; i++)
        {
            if(stringsEqual(allCustomers[i].cname, _cname))
            {
                        //update rating
                if(ifIncrease)
                {
                    allCustomers[i].upvotes ++;
                    if(allCustomers[i].upvotes > 5)
                    {
                        addKYC(_cname, allCustomers[i].bank);
                    }
                }
               else
               {
                    allCustomers[i].upvotes --;
                    if(allCustomers[i].upvotes < 5)
                    {
                        removeKYC(_cname);
                    }
                }
            }    
        return 0;
        }
    }

    function downVoteBank(address _baddress) public
    {
      for (uint i=0; i<allOrgs.length; i++)
       {
           if(allOrgs[i].baddress == _baddress)
           {
               allOrgs[i].downvotes++;
           }
       }  
    }
   
   function stringsEqual(string storage _a, string memory _b) internal view returns (bool)
   {
    bytes storage a = bytes(_a);
    bytes memory b = bytes(_b);
       if (a.length != b.length)
       return false;
            // @todo unroll this loop
            for (uint i = 0; i < a.length; i ++)
                {

                    if (a[i] != b[i])
                    return false;

                }
    return true;
    }
   
}
