pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MetaVote1.sol";

contract TestMetaVote1 {

  function testInitialBalanceUsingDeployedContract() public {
    MetaVote1 meta = MetaVote1(DeployedAddresses.MetaVote1());

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaVote1 initially");
  }

  function testInitialBalanceWithNewMetaVote1() public {
    MetaVote1 meta = new MetaVote1();

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaVote1 initially");
  }

}
