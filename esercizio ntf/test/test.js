
const truffleAssert = require('truffle-assertions');
const ntf = artifacts.require('./NTF.sol')


contract('NTF', (accounts) => {
    let contract
  
    before(async () => {
      contract = await ntf.deployed()
    })


    describe('deployment', async () => {
        it('deploys successfully', async () => {
        const address = contract.address
        assert.notEqual(address, 0x0)
        assert.notEqual(address, '')
        assert.notEqual(address, null)
        assert.notEqual(address, undefined)
        }
    )})




    describe('minting', async () => {

        it('creates a new token', async () => {
          const result = await contract.mint('abc',{from:"0x0a578aCd9291A13440ec02F0dD0C67673003A9AC"});
          const sale=await contract.setForSale(1,10,{from:"0x0a578aCd9291A13440ec02F0dD0C67673003A9AC"});
            
          console.log(await contract.getPrezzo(1));
          console.log(await contract.contr());
        
          const totalSuppl = await contract.numberOfTokens()
          console.log(totalSuppl.length);
          const totalSupply=totalSuppl.length;
         // SUCCESS
          assert.equal(totalSupply, 1)


/*
          const totalSuppl = await contract.numberOfTokens()
          console.log(totalSuppl.length);
          const totalSupply=totalSuppl.length;
         // SUCCESS
          assert.equal(totalSupply, 1)
          const event = await result.logs[0].args
          console.log(event)
          assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
          assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
          //assert.equal(event.to, accounts[0], 'to is correct')
          // FAILURE: cannot mint same color twice
         //await contract.mint('064ddc968931b84829a29d908e2a17ff239fe715b9ca390336d125510f92f04e').should.be.rejected;
            
       */
       
       
       
        })
/*
        it("shuld fail",async function(){
            await truffleAssert.reverts(contract.mint('064ddc968931b84829a29d908e2a17ff239fe715b9ca390336d125510f92f04e'))
        });

*/




      })

})
