pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NTF is ERC721{
    using Counters for Counters.Counter;
    //Contatore utilizzato per rappresentare i token
    Counters.Counter private _tokenIds;

    // mapping tra un tokenId e il suo hash(e viceversa)
    mapping (uint256 =>  string) idToHash;
    mapping (string =>  uint256) hashToId;
    // associa un prezzo in Wei ad ogni token
    //ogni token inizialmente ha valore 0 -> non è in vendita
    mapping (uint256 => uint256) prezzo;

    //costruttore con due parametri:
    //"opera" è il nome di un singolo token
    //"OperaHub" è il nome che rappresenta l'insieme dei token del contratto
    constructor() ERC721("opera","OperaHub") public{}

//GETTER:
//del prezzo di un token
function getPrezzo(uint256 _tokenId) view public returns (uint256){
    return prezzo[_tokenId];
}

//numero di token
function numberOfTokens()  view public returns (uint256){
    return _tokenIds.current();
}


// funzione che prende in input token e il suo costo in Wei e lo mette in vendita
function setForSale(uint256 _tokenId,uint256 costo) external{
    address owner = ownerOf(_tokenId);
    //il prezzo del token non deve essere 0(mai stato settato) e il sender deve
    //essere il proprietario del token
    require(prezzo[_tokenId]==0);
    require(owner == msg.sender);
    prezzo[_tokenId]=costo;
    //esegue l'approval della chiave del contratto, permettendo a quest ultimo
    //di accedere ai token ed effettuare modifiche
    approve(address(this), _tokenId);
    //emit Approval(owner, address(this), _tokenId);
    }


//Funzione che effettua lo scambio tra il token e il prezzo in Wei
    function buy(uint256 _tokenId) external  payable {
        address buyer = msg.sender;
        uint256 payedPrice = msg.value;
        //proprietario del token
        address ownerA =ownerOf(_tokenId);
        //payable permette all'owner del token di ricevere i token dal buyer
        address payable owner= payable(ownerA);
        require(prezzo[_tokenId]>0,"OPERA NON IN VENDITA.");
        require(getApproved(_tokenId) == address(this),"INDIRIZZO CONTRATTO NON APPROVATO.");
        require(payedPrice >= prezzo[_tokenId],"NON HAI I SORDI, SEI N PORACCIO.");
        //effettua la transazione in Wei
        owner.transfer(prezzo[_tokenId]);
        //cambia il proprietario del token
        _transfer(owner,buyer,_tokenId);
        //venduto il token, viene rimosso dagli oggetti in vendita
        prezzo[_tokenId]=0;
}

//funzione per la creazione di un nuovo token, associando il proprietario
//alla chiave pubblica del chiamante della funzione
    function mint(string memory hashh) public{
        _tokenIds.increment();
        //crea l'id per il nuovo token
        uint256 newItemId = _tokenIds.current();


//controllo hash duplicati
        //require(compare(idToHash[newItemId],""),"hash gia esistente");
        require(hashToId[hashh]==0,"hash gia esistente");

//funzione che crea il nuovo token
        _mint(msg.sender, newItemId);
        idToHash[newItemId]=hashh;
        hashToId[hashh]=newItemId;
    }




//funzione che confronta due stringhe(solidity non ce l'ha)
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
