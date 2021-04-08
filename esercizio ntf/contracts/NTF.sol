pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NTF is ERC721{
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;


    mapping (uint256 =>  string) idToHash;
    mapping (string =>  uint256) hashToId;


    //mapping (uint256 => bool) forSale;
    mapping (uint256 => uint256) prezzo;


    constructor() ERC721("opera","OperaHub") public{}



function getPrezzo(uint256 _tokenId) view public returns (uint256){
    return prezzo[_tokenId];
}




function setForSale(uint256 _tokenId,uint256 costo) external{
    address owner = ownerOf(_tokenId);
    require(prezzo[_tokenId]==0);
    require(owner == msg.sender);
    prezzo[_tokenId]=costo;
    approve(address(this), _tokenId);
    //emit Approval(owner, address(this), _tokenId);
    }




    function buy(uint256 _tokenId) external  payable {
        address buyer = msg.sender;
        uint256 payedPrice = msg.value;
        address ownerA =ownerOf(_tokenId);
        address payable owner= payable(ownerA);
        require(prezzo[_tokenId]>0,"a");
        require(getApproved(_tokenId) == address(this),"b");
        require(payedPrice >= prezzo[_tokenId],"s");
        owner.transfer(prezzo[_tokenId]);
        _transfer(owner,buyer,_tokenId);
        prezzo[_tokenId]=0;
}



    function numberOfTokens()  view public returns (uint256){
        return _tokenIds.current();
    }



    function mint(string memory hashh) public{
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();


//controllo hash duplicati
        require(compare(idToHash[newItemId],""),"gia esistente");
        require(hashToId[hashh]==0,"gia esistente");

        _mint(msg.sender, newItemId);
        idToHash[newItemId]=hashh;
        hashToId[hashh]=newItemId;
    }














      function compare(string memory _s1, string memory _s2) 
            pure
            internal 
            returns(bool) {
              bytes memory b1 = bytes(_s1);
              bytes memory b2 = bytes(_s2);
              if (b1.length != b2.length) {
                return false;
              }
              return keccak256(b1) == keccak256(b2);
  }






}