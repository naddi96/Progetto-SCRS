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
		votoIndividuale[0xC5237E5A1D76776fbd990f8c07B30D45A831EC90]=true;
		votoIndividuale[0x013E185Fd114c18bE59F0B3d4D5bF28950472563]=true;
		votoIndividuale[0x93400A85883011B71469c0a78241CEB6aa5Df266]=true;

		//insieme dei candidati


		numerodiVoti[0x9317cf52eD55E11d18C7e2D2DD375bE87B241685]=0;
		numerodiVoti[0x6aF99dF5D4F4d283E89967f2ed613e6736B3B7f6]=0;

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
