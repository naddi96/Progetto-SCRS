//const { MSPID_SCOPE_SINGLE } = require("fabric-network/lib/impl/query/defaultqueryhandlerstrategies");
function prettyJSONString(inputString) {
	return JSON.stringify(JSON.parse(inputString), null, 2);
}

async function requests(contract){
            
            // Let's try a query type operation (function).
			// This will be sent to just one peer and the results will be shown.
			console.log('\n--> Evaluate Transaction: GetAllAssets, function returns all the current assets on the ledger');
			let result = await contract.evaluateTransaction('GetAllAssets');
			console.log(`*** Result: ${prettyJSONString(result.toString())}`);

			/*
            console.log('\n--> Evaluate Transaction: ReadAsset, function returns an asset with a given assetID');
			result = await contract.evaluateTransaction('ReadAsset', 'asset13');
			console.log(`*** Result: ${prettyJSONString(result.toString())}`);
			*/

			console.log('\n--> Evaluate Transaction: AssetExists, function returns "true" if an asset with given assetID exist');
			result = await contract.evaluateTransaction('AssetExists', 'asset1');
			console.log(`*** Result: ${prettyJSONString(result.toString())}`);

            console.log('\n--> Evaluate Transaction: ReadAsset, function returns "asset1" attributes');
			result = await contract.evaluateTransaction('ReadAsset', 'asset1');
			console.log(`*** Result: ${prettyJSONString(result.toString())}`);

            console.log('\n--> Submit Transaction: TransferAsset asset1, transfer to new owner of Tom');
			await contract.submitTransaction('TransferAsset', 'asset1', 'Tom');
			console.log('*** Result: committed');

			console.log('\n--> Evaluate Transaction: ReadAsset, function returns "asset1" attributes');
			result = await contract.evaluateTransaction('ReadAsset', 'asset1');
			console.log(`*** Result: ${prettyJSONString(result.toString())}`);

			console.log('\n--> Evaluate Transaction: DeleteAssetFromOwner');
			result = await contract.evaluateTransaction('DeleteAssetFromOwner', 'Tomoko');
			console.log(`*** Result: ${prettyJSONString(result.toString())}`);

			console.log('\n--> Evaluate Transaction: ReadAsset, function returns "asset8" attributes');
			result = await contract.evaluateTransaction('ReadAsset', 'asset8');
			console.log(`*** Result: ${prettyJSONString(result.toString())}`);
}

module.exports = {requests};