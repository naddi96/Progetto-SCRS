// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaVote1 {
	mapping (address => uint) numerodiVoti;
	mapping (address => bool) votoIndividuale;
	
	address [] listaCandidati;
	//event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor() public {

		//insieme dei votanti
		votoIndividuale[0xDC42098bB91898eC2f419857C916cC78C23301dA]=true;
		votoIndividuale[0x0a578aCd9291A13440ec02F0dD0C67673003A9AC]=true;
		votoIndividuale[0xC4CA1e4BCceb3BAaea373F1a2EE5eC2939c75EF2]=true;

		//insieme dei candidati


		numerodiVoti[0x9317cf52eD55E11d18C7e2D2DD375bE87B241685]=0;
		numerodiVoti[0xe3FEf91d6daA4fd73ceE4a60132a5C25d8ED056d]=0;

	}

	function vota(address candidato) public returns(bool sufficient) {
		if (votoIndividuale[msg.sender]){
			numerodiVoti[candidato] += 1;
			votoIndividuale[msg.sender]=false;
			return true;
		}
		return false;
	}


/*    
	function getTuttiVoti() public view returns (string [] memory) {
		string [] memory  ret;
		string memory stri ;
		for(int i=0; i<listaCandidati.length;i++){
			address indirizzo = listaCandidati[i];
			uint numVoti = numerodiVoti[indirizzo];
			stri =" VOTI:"+string(numVoti)+"..." + string(indirizzo);
			ret.append(stri);
		}
		
		return numerodiVoti;
	}
*/


	function getNumeroVoti(address candindato) public view returns(uint){
		return numerodiVoti[candindato];
	}

/*
	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		//emit Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}

	*/
}
