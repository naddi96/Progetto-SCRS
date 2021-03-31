pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MetaVote2.sol";

contract TestMetaVote2 {

  function testInitialBalanceUsingDeployedContract() public {
    MetaVote2 meta = MetaVote2(DeployedAddresses.MetaVote2());

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaVote2 initially");
  }

  function testInitialBalanceWithNewMetaVote2() public {
    MetaVote2 meta = new MetaVote2();

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaVote2 initially");
  }

}
