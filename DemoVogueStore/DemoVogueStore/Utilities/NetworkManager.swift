//
//  NetworkManager.swift
//  DemoVogueAPI
//
//  Created by Bharat Byan on 11/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import Foundation
import SwiftyJSON

// Network request model
class Model_Request
{
    var str_BaseUrl: String?
    var str_ActionUrl: String?
    var str_ActionName: String?
    var str_PostData: String?
    var dict_Json: Dictionary< String, Any>? // use dictionary for passing custom POST parameters
}

// Creating network parsing protocol
protocol NetworkParsingProtocol
{
    func getData(data:JSON?,error:Error?)
}

class NetworkManager: NSObject, URLSessionDataDelegate, URLSessionTaskDelegate
{
    var delegateNetworkProtocol: NetworkParsingProtocol?
    
    //Fetching a files of content only
    func callWebService(model: Model_Request){
        let strURL = URL_Common + Action_URL + Action_Name
        var data: Data? = nil
        
        // creating custom queue for asynchronous calling
        let queueApiCall = DispatchQueue(label: "task_fetch_loyalitypoints")
        
        queueApiCall.async {
            if let strUrl = URL(string: strURL) {
                do {
                    data = try Data(contentsOf: strUrl)
                    let strResponseInISOLatin = String(data: data!, encoding: String.Encoding.isoLatin1)
                    if let dataFromString = strResponseInISOLatin!.data(using: .utf8, allowLossyConversion: false) {
                        let json = try JSON(data: dataFromString)
                        self.delegateNetworkProtocol!.getData(data: json, error: nil)
                    }
                } catch {
                    self.delegateNetworkProtocol!.getData(data: nil, error: error)
                    print(error.localizedDescription)
                    // or display a dialog
                }
            }
        }
    }
}
