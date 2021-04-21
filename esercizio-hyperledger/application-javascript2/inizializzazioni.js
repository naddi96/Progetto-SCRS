async function inizializza(contract){
    // Initialize a set of asset data on the channel using the chaincode 'InitLedger' function.
    // This type of transaction would only be run once by an application the first time it was started after it
    // deployed the first time. Any updates to the chaincode deployed later would likely not need to run
    // an "init" type function.		!!!!!!!!!!!!!!! only once

    console.log('\n--> Submit Transaction: InitLedger, function creates the initial set of assets on the ledger');
    await contract.submitTransaction('InitLedger');
    console.log('*** Result: committed');

    ////////////// CREA NUOVO ASSET

    // Now let's try to submit a transaction.
    // This will be sent to both peers and if both peers endorse the transaction, the endorsed proposal will be sent
    // to the orderer to be committed by each of the peer's to the channel ledger.
    console.log('\n--> Submit Transaction: CreateAsset, creates new asset with ID, color, owner, size, and appraisedValue arguments');
    result = await contract.submitTransaction('CreateAsset', 'asset20999', 'yellow', '5', 'Tom', '1300');
    console.log('*** Result: committed');
    if (`${result}` !== '') {
        console.log(`*** Result: ${prettyJSONString(result.toString())}`);
    }
    }

module.exports = {inizializza};

