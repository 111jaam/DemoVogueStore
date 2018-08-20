//
//  VSManagerVogueList.swift
//  DemoVogueAPI
//
//  Created by Bharat Byan on 11/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import Foundation
import SwiftyJSON

class VSManagerVogueList{
    
    static let sharedInstance = VSManagerVogueList()
    var delegateManager: VSManagerVogueListProtocol?
    
    //Creating a network request
    func createRequest()
    {
        //Passing various network related parameters
        //below we can use POST parameters for creating requests also
        
        let myRequest:Model_Request = Model_Request()
        myRequest.str_BaseUrl = URL_Common
        myRequest.str_ActionUrl = Action_URL
        myRequest.str_ActionName = Action_Name
        
        // initialising network request class
        let webObj: NetworkManager = NetworkManager()
        webObj.delegateNetworkProtocol = self
        webObj.callWebService(model: myRequest)
    }
}

// custom protocol for sending data to view controller
protocol VSManagerVogueListProtocol
{
    func sendData(arrayOfViewModel: Array<VSViewModelVogue>, error: Error?)
}

// MARK:-- Network Protocol Delegation
extension VSManagerVogueList: NetworkParsingProtocol
{
    func getData(data: JSON?, error: Error?) {

        var arrViewModel: [VSViewModelVogue] = []
       
        //checking for errors, on succes only proceeding
        if error == nil {
            
            // looping through the data and creating a viewmodel array using models
            
            for (index, _) in data!["data"].enumerated(){
                let itemVogue = data!["data"][index]
                let modelParsed = VSModelVogue(obj: itemVogue) // creating model
                let viewModel = VSViewModelVogue(modelParsed) // creating viewmodel
                arrViewModel.append(viewModel) // adding to the array of viewmodel
            }
            
            // passing empty viewmodel array only
            delegateManager?.sendData(arrayOfViewModel: arrViewModel, error: nil)
        }else{
            
            // passing empty viewmodel array and error value
            delegateManager?.sendData(arrayOfViewModel: arrViewModel, error: error)
        }
    }
}
