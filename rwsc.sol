pragma solidity ^0.4.20;


contract RWSC{

string public name;
string public symbol;
uint8 public decimals = 8;
uint256 public totalSupply;
uint public total;

mapping (address => uint256) public balanceOf;

event Transfer(address indexed from, address indexed to, uint256 value);

address owner;

uint256 initialSupply = 888888888;
string tokenName = 'Real World Smart Contract';
string tokenSymbol = 'RWSC';
constructor () public {

totalSupply = initialSupply*10**uint256(decimals);
balanceOf[msg.sender] = totalSupply;
name = tokenName;
symbol = tokenSymbol;

owner = msg.sender;
total =0;
}

function _transfer(address _from, address _to, uint _value) internal {
require(_to != 0x0);
require(balanceOf[_from] >= _value);
require(balanceOf[_to] + _value >= balanceOf[_to]);

uint previousBalances = balanceOf[_from] + balanceOf[_to];

balanceOf[_from] -= _value;
balanceOf[_to] += _value;

emit Transfer(_from, _to, _value);
assert(balanceOf[_from] + balanceOf[_to] == previousBalances);

}

function transfer (address _to, uint256 _value) public returns (bool success) {
_transfer(msg.sender, _to, _value);
return true;
}

modifier onlyOwner() {
require(msg.sender == owner);
_;
}

function transferOwnership(address newOwner) public onlyOwner {
require(newOwner != address(0));
owner = newOwner;
}

struct codeProperties{
address holdingAddress;
uint timeStamp;
uint value;
uint status;
}

mapping (string => codeProperties) codeMapping;

mapping(address => uint) public addressBalances;

mapping(uint => string) public idCodes;



function createEntry(string _code, address _holdingAddress, uint _timeStamp) public onlyOwner{
var details = codeMapping[_code];
details.holdingAddress = _holdingAddress;
details.timeStamp = _timeStamp;
details.value = 1;
details.status = 0;
addressBalances[_holdingAddress] += 1;
total = total + 1;
idCodes[total] = _code;
// unconfirmedEntry.push(id);
}

function returnTotal() view returns(uint){
return total;
}

function returnCode(uint _id) view returns(string){
return idCodes[_id];
}

function returnStatus(string _code) view returns(uint){
var details = codeMapping[_code];
uint status = details.status;
return status;
}

function release(string _code) public onlyOwner{
var details = codeMapping[_code];
uint ts = details.timeStamp;
require(now >= ts);
address beneficiary = details.holdingAddress;
addressBalances[beneficiary] = 0;
balanceOf[owner] -= 1*10**uint256(decimals);
balanceOf[beneficiary] += 1*10**uint256(decimals);
details.status = 1;

}

function releaseAll() public onlyOwner{
for (uint i =1; i <= total; i++){
string _code = idCodes[i];
var details = codeMapping[_code];
uint status = details.status;
if(status == 0 && details.timeStamp < now){
release(_code);
}
}
}



function retvalues(string _code) public view returns(address, uint, uint, uint) {
var details = codeMapping[_code];
return(details.holdingAddress, details.timeStamp, details.value, details.status);
}


}