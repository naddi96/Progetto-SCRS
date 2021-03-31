const MetaVote1 = artifacts.require("MetaVote1");

contract('MetaVote1', (accounts) => {
  it('should put 10000 MetaVote1 in the first account', async () => {
    const metaVote1Instance = await MetaVote1.deployed();
    const balance = await metaVote1Instance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const metaVote1Instance = await MetaVote1.deployed();
    const metaVote1Balance = (await metaVote1Instance.getBalance.call(accounts[0])).toNumber();
    const metaVote1EthBalance = (await metaVote1Instance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(metaVote1EthBalance, 2 * metaVote1Balance, 'Library function returned unexpected function, linkage may be broken');
  });
  it('should send coin correctly', async () => {
    const metaVote1Instance = await MetaVote1.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await metaVote1Instance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await metaVote1Instance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await metaVote1Instance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await metaVote1Instance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await metaVote1Instance.getBalance.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
});
