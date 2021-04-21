
async function updates(contract){
    console.log('\n--> Submit Transaction: UpdateAsset asset1, change the appraisedValue to 350');
    await contract.submitTransaction('UpdateAsset', 'asset1', 'blue', '5', 'Tomoko', '350');
    console.log('*** Result: committed');

    try {
        // How about we try a transactions where the executing chaincode throws an error
        // Notice how the submitTransaction will throw an error containing the error thrown by the chaincode
        console.log('\n--> Submit Transaction: UpdateAsset asset70, asset70 does not exist and should return an error');
        await contract.submitTransaction('UpdateAsset', 'asset70', 'blue', '5', 'Tomoko', '300');
        console.log('******** FAILED to return an error');
    } catch (error) {
        console.log(`*** Successfully caught the error: \n    ${error}`);
    }
}

module.exports = {updates};
