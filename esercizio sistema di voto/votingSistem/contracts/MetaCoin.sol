// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
	mapping (address => uint) numerodiVoti;
	mapping (address => bool) votoIndividuale;
	
	address [] listaCandidati;
	//event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor() public {

		//insieme dei votanti
		votoIndividuale[0x9aD86328e419E0c42A2D9220C51ff94E29faae63]=true;
		votoIndividuale[0x0B64888c070d306d89002e1e478c93e0fC84e1a2]=true;
		votoIndividuale[0x9aD86328e419E0c42A2D9220C51ff94E29faae63]=true;

		//insieme dei candidati


		numerodiVoti[0x5D05744b8D57c70251DB4a87df17D08de64f5Dd6]=0;
		numerodiVoti[0x6ab74e04bd4e7477Ab23D6d96208A9350076e972]=0;

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
