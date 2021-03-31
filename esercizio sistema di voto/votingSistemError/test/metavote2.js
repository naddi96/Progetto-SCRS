const MetaVote2 = artifacts.require("MetaVote2");

contract('MetaVote2', (accounts) => {
  it('should put 10000 MetaVote2 in the first account', async () => {
    const MetaVote2Instance = await MetaVote2.deployed();
    const balance = await MetaVote2Instance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const MetaVote2Instance = await MetaVote2.deployed();
    const MetaVote2Balance = (await MetaVote2Instance.getBalance.call(accounts[0])).toNumber();
    const MetaVote2EthBalance = (await MetaVote2Instance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(MetaVote2EthBalance, 2 * MetaVote2Balance, 'Library function returned unexpected function, linkage may be broken');
  });
  it('should send coin correctly', async () => {
    const MetaVote2Instance = await MetaVote2.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await MetaVote2Instance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await MetaVote2Instance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await MetaVote2Instance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await MetaVote2Instance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await MetaVote2Instance.getBalance.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
});
