pragma solidity ^0.5.8;

contract charityRegistry {
    address owner;
    
    struct charityInfo{
        string name;
        address payable addr;
        uint amount;
    }
    
    charityInfo[] charityList;
    mapping(address => charityInfo[]) donationInfo;
    
    event logCharityRegistered(string chname, address charityAddr);
    event logDonations(address dAddr, string chname, address charityAddr, uint amount);

    constructor() public {
        owner = msg.sender;
    }
    
    modifier ownerOnly {
        require(msg.sender == owner,"provide address is not owner");
        _;
    }
    
    function isRegistered(address charityAddr) private view returns(bool){
        uint index = findIndexByAddr(charityList, charityAddr);
        if(index != uint(-1)) {return true;}
    }
    
    function listRegisteredAddr() public view returns(address[] memory addr){
        require(charityList.length > 0,"no charity info");
        address[] memory addrlist = new address[](charityList.length);
        for(uint i = 0; i < charityList.length; i++){
            addrlist[i] = charityList[i].addr;
        }
        return (addrlist);
    }
    
    function getDonationInfo(uint256 index) public view returns(address, uint){
        require(donationInfo[msg.sender].length > 0,"no donation info");
        return (donationInfo[msg.sender][index].addr, donationInfo[msg.sender][index].amount);
    }
    
    function updateList(address dAddr, address charityAddr,uint dindex) private {
        uint index = findIndexByAddr(charityList, charityAddr);
        uint amount = donationInfo[dAddr][dindex].amount;
        charityList[index].amount += amount;
    }
    
    function registerCharity(string memory name, address payable charityAddr) public ownerOnly {
        require(!isRegistered(charityAddr),"charity address is already registered");
        charityList.push(charityInfo(name, charityAddr, 0));
        emit logCharityRegistered(name, charityAddr);
    }
    
    function findIndexByAddr(charityInfo[] memory list,address addr) private pure returns(uint index){
        for(uint i; i < list.length; i++){
            if (list[i].addr == addr) {
                return uint(i);
            }
        }
        return uint(-1);
    }
    
    function Donate(address payable charityAddr) public payable {
        require(isRegistered(charityAddr),"charity address is not registered");
        string memory name = charityList[findIndexByAddr(charityList, charityAddr)].name;
        uint index = findIndexByAddr(donationInfo[msg.sender], charityAddr);
        if(index == uint(-1)) {
            donationInfo[msg.sender].push(charityInfo(name,charityAddr,msg.value));
            index = donationInfo[msg.sender].length - 1;
        } else {
            donationInfo[msg.sender][index].amount += msg.value;
        }
        updateList(msg.sender, charityAddr, index);
        emit logDonations(msg.sender, name, charityAddr, msg.value);
    }
    
    function releaseFunds() public ownerOnly {
        require(address(this).balance > 0, "no funds to release");
        for(uint i; i < charityList.length; i++){
            if(charityList[i].amount != 0) {
            charityList[i].addr.transfer(charityList[i].amount);
            charityList[i].amount = 0;
            
            }
        }
    }
}