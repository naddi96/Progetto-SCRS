package chaincode

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
    
)

// SmartContract provides functions for managing an Asset
type SmartContract struct {
	contractapi.Contract
}

// Asset describes basic details of what makes up a simple asset

type AssetOwner struct {
	ID      string   `json:"ID"`
	Nome    string   `json:"nome"`
	Cognome string   `json:"cognome"`
	Fiorini int      `json:"fiorini"`
	Vetture []string `json:"vetture"`
}

type Asset struct {
		ID             string `json:"ID"`
		Color          string `json:"color"`
		Size           int    `json:"size"`
		Owner          string `json:"owner"`
		PrezzoVendita int    `json:"prezzoVendita"`
		PrezzoAcquisto int    `json:"prezzoAcquisto"`
	}




/*
// funzione lista autovetture di un prop
func (s *SmartContract)  GetAutovettureProp(ctx contractapi.TransactionContextInterface, id string) (*[]string, error) {
	//assetJSON, err := ctx.GetStub().GetState("tipo~idpersona"+id)
	resultsIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("tipo~id", []string{"persona",id})

	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}

	xx,_ :=resultsIterator.Next()
	assetJSON:=xx.GetValue()
	if assetJSON == nil {
		return nil, fmt.Errorf(xx.GetKey()+ " the asset %s does not exist", id)
	}
	var asset AssetOwner
	err = json.Unmarshal(assetJSON, &asset)
	if err != nil {
		return nil, err
	}
	var x = &asset.Vetture
	return x, nil
}
*/










//elencare tutte le auto
func (s *SmartContract) GetAllCars(ctx contractapi.TransactionContextInterface) ([]*Asset, error) {
	// range query with empty string for startKey and endKey does an
	// open-ended query of all assets in the chaincode namespace.
	resultsIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("tipo~id", []string{"macchina"})
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var assets []*Asset
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var asset Asset
		err = json.Unmarshal(queryResponse.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}

	return assets, nil
}




//elencare tutti i prop
func (s *SmartContract) GetAllOwner(ctx contractapi.TransactionContextInterface) ([]*AssetOwner, error) {
	// range query with empty string for startKey and endKey does an
	// open-ended query of all assets in the chaincode namespace.
	resultsIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("tipo~id", []string{"persona"})
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var assets []*AssetOwner
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var asset AssetOwner
		err = json.Unmarshal(queryResponse.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}

	return assets, nil
}



func findAndDelete(s []string, item string) []string {
    index := 0
    for _, i := range s {
        if i != item {
            s[index] = i
            index++
        }
    }
    return s[:index]
}

//transazione autovettura tra due prop

func (s *SmartContract) Trasferisci(ctx contractapi.TransactionContextInterface, aqquirente string,venditore string,macchina string) ( string) {
	
	aqu,_ := s.ReadAssetOwner(ctx,aqquirente)
	ven,_:= s.ReadAssetOwner(ctx,venditore)
	mac,_ := s.ReadAuto(ctx,macchina)

	if mac.PrezzoVendita != -1 && mac.PrezzoVendita <= aqu.Fiorini{
		aqu.Vetture = append(aqu.Vetture, mac.ID)
		ven.Vetture = findAndDelete(ven.Vetture,mac.ID)
		mac.Owner=aqu.ID
		mac.PrezzoAcquisto=mac.PrezzoVendita
		mac.PrezzoVendita=-1
		aqu.Fiorini=aqu.Fiorini-mac.PrezzoVendita
		ven.Fiorini=ven.Fiorini+mac.PrezzoVendita
		s.UpdateAssetOwner(ctx,aqu.ID,aqu.Nome,aqu.Cognome,aqu.Fiorini,aqu.Vetture)
		s.UpdateAssetOwner(ctx,ven.ID,ven.Nome,ven.Cognome,ven.Fiorini,ven.Vetture)
		s.UpdateAssetVettura(ctx,mac.ID,mac.Color,mac.Size,mac.Owner,mac.PrezzoVendita,mac.PrezzoAcquisto)
		return "successo"
	}

	return "soldi non sufficienti" 
}












//mostrare caratteristiche della autovettura

func (s *SmartContract) ReadAuto(ctx contractapi.TransactionContextInterface,id string) (*Asset, error) {
		// range query with empty string for startKey and endKey does an
		// open-ended query of all assets in the chaincode namespace.
		resultsIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("tipo~id", []string{"macchina",id})
		if err != nil {
			return nil, err
		}
		defer resultsIterator.Close()
	
		var assets []*Asset
		for resultsIterator.HasNext() {
			queryResponse, err := resultsIterator.Next()
			if err != nil {
				return nil, err
			}
	
			var asset Asset
			err = json.Unmarshal(queryResponse.Value, &asset)
			if err != nil {
				return nil, err
			}
			assets = append(assets, &asset)
		}
		dd:=assets[0]
		return dd, nil
	
}







// InitLedger adds a base set of assets to the ledger
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {


	assets := []Asset{
		{ID: "1", Color: "blue", Size: 5, Owner: "1", PrezzoVendita: -1, PrezzoAcquisto:300},
		{ID: "2", Color: "red", Size: 5, Owner: "1", PrezzoVendita: -1, PrezzoAcquisto:300},
		{ID: "3", Color: "green", Size: 10, Owner: "2", PrezzoVendita: -1, PrezzoAcquisto:300},
		{ID: "4", Color: "yellow", Size: 10, Owner: "3", PrezzoVendita: 200, PrezzoAcquisto:300},

	}
	for _, asset := range assets {
		assetJSON, err := json.Marshal(asset)
		if err != nil {
			return err
		}


        key,err:=ctx.GetStub().CreateCompositeKey("tipo~id",[]string{"macchina",asset.ID})
		if err != nil {
			return err
		}
		
		err = ctx.GetStub().PutState(key, assetJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %v", err)
		}
	}



	assetsOwn := []AssetOwner{
		{ ID:"1",Nome:"Giovanni",Cognome: "Rossi",Fiorini: 3000, Vetture:[]string{ "1","2"} },
		{ ID:"2",Nome:"Giovanna",Cognome: "Rossa",Fiorini: 3000, Vetture:[]string{ "3"} },
		{ ID:"3",Nome:"Mariagiovanna",Cognome: "Rosa",Fiorini: 3000, Vetture:[]string{ "4"} },

	} 


	for _, assetOwn := range assetsOwn {
		assetJSON, err := json.Marshal(assetOwn)
		if err != nil {
			return err
		}


        key,err:=ctx.GetStub().CreateCompositeKey("tipo~id",[]string{"persona",assetOwn.ID})
		if err != nil {
			return err
		}
		
		err = ctx.GetStub().PutState(key, assetJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %v", err)
		}
	}



	return nil
}

// CreateAsset issues a new asset to the world state with given details.
func (s *SmartContract) CreateVettura(ctx contractapi.TransactionContextInterface, id string, color string, size int, owner string, prezzoVendita int, prezzoAcquisto int) error{
	exists, err := s.AssetExists(ctx, "macchina",id)
	if err != nil {
		return err

	}
	if exists {
		return fmt.Errorf("the asset %s already exists", id)
	}

	
	asset := Asset{
		ID:             id,
		Color:          color,
		Size:           size,
		Owner:          owner,
		PrezzoVendita: prezzoVendita,
		PrezzoAcquisto: prezzoAcquisto,
	}
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err	
	}
	key,err:=ctx.GetStub().CreateCompositeKey("tipo~id",[]string{"macchina",asset.ID})
	if err != nil {
		return err
	}
	
	err = ctx.GetStub().PutState(key, assetJSON)
	if err != nil {
		return fmt.Errorf("failed to put to world state. %v", err)
	}

	return nil
}



// ReadAsset returns the asset stored in the world state with given id
func (s *SmartContract) ReadAssetOwner(ctx contractapi.TransactionContextInterface, id string) (*AssetOwner, error) {
	// open-ended query of all assets in the chaincode namespace.
	resultsIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("tipo~id", []string{"persona",id})
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var assets []*AssetOwner
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var asset AssetOwner
		err = json.Unmarshal(queryResponse.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}
	dd:=assets[0]
	return dd, nil
}


func (s *SmartContract) UpdateAssetOwner(ctx contractapi.TransactionContextInterface, id string, nome string, cognome string,fiorini int, vetture []string) error {
	exists, err := s.AssetExists(ctx,"persona" ,id)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the asset %s does not exist", id)
	}

	// overwriting original asset with new asset
	asset := AssetOwner{
		ID:             id,
		Nome:          nome,
		Cognome:           cognome,
		Fiorini:          fiorini,
		Vetture:      vetture,
	}
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	key,err:=ctx.GetStub().CreateCompositeKey("tipo~id",[]string{"persona",asset.ID})
	if err != nil {
		return err
	}
	return ctx.GetStub().PutState(key, assetJSON)
}




// UpdateAsset updates an existing asset in the world state with provided parameters.
func (s *SmartContract) UpdateAssetVettura(ctx contractapi.TransactionContextInterface, id string, color string, size int, owner string, prezzoVendita int, prezzoAcquisto int) error {
	exists, err := s.AssetExists(ctx, "macchina",id)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the asset %s does not exist", id)
	}

	// overwriting original asset with new asset
	asset := Asset{
		ID:             id,
		Color:          color,
		Size:           size,
		Owner:          owner,
		PrezzoVendita: prezzoVendita,
		PrezzoAcquisto: prezzoAcquisto,
	}
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	key,err:=ctx.GetStub().CreateCompositeKey("tipo~id",[]string{"macchina",asset.ID})
	if err != nil {
		return err
	}
	return ctx.GetStub().PutState(key, assetJSON)
}

// DeleteAsset deletes an given asset from the world state.
/*
func (s *SmartContract) DeleteAsset(ctx contractapi.TransactionContextInterface, id string) error {
	exists, err := s.AssetExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the asset %s does not exist", id)
	}

	return ctx.GetStub().DelState(id)
}*/

// AssetExists returns true when asset with given ID exists in world state
func (s *SmartContract) AssetExists(ctx contractapi.TransactionContextInterface,tipo string, id string) (bool, error) {
	resultsIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("tipo~id", []string{tipo,id})

//	key,_:=ctx.GetStub().CreateCompositeKey("tipo~id",[]string{"persona",id})
//	assetJSON, err := ctx.GetStub().GetState(key)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}
//	return assetJSON != nil, nil

	return resultsIterator.HasNext(), nil
}

// TransferAsset updates the owner field of asset with given id in world state.
/*func (s *SmartContract) TransferAsset(ctx contractapi.TransactionContextInterface, id string, newOwner string) error {
	asset, err := s.ReadAsset(ctx, id)
	if err != nil {
		return err
	}

	asset.Owner = newOwner
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, assetJSON)
}*/
/*
// GetAllAssets returns all assets found in world state
func (s *SmartContract) GetAllAssets(ctx contractapi.TransactionContextInterface) ([]*AssetOwner, error) {
	// range query with empty string for startKey and endKey does an
	// open-ended query of all assets in the chaincode namespace.
	resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var assets []*AssetOwner
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var asset AssetOwner
		err = json.Unmarshal(queryResponse.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}

	return assets, nil
}
*/