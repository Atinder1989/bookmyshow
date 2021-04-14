//
//  ServiceManager.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import UIKit

class ServiceManager: NSObject {
    
    class func processDataFromServer<T:Codable>(service: Service,model:T.Type,responseProcessingBlock: @escaping (T?,Error?) -> () )
    {
 
        if Utility.isNetworkAvailable() {
            let request = RequestManager.sharedInstance.createRequest(service: service)
                SessionManager.sharedInstance.processRequest(request: request) { (data, error) in
                    ServiceManager.processDataModalFromResponseData(service: service, model:T.self,data: data,error: error,responseProcessingBlock: responseProcessingBlock)
            }
        } else {
            let error: NSError = NSError.init(domain: "", code: 0,
                                                         userInfo: [NSLocalizedDescriptionKey: ""])
            responseProcessingBlock(nil, error)
        }
    }
    
    private class func processDataModalFromResponseData<T:Codable>(service:Service,model:T.Type, data:Data?,error:Error?,responseProcessingBlock: @escaping (T?,Error?) -> ())
    {
        if let responseError = error
        {
            responseProcessingBlock(nil,responseError)
            return
        }
        
        if let responseData = data
        {
            do{
                _ = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String:Any]
                let jsonDecoder = JSONDecoder.init()
                let parsingModel = try jsonDecoder.decode(model.self, from: responseData)
                responseProcessingBlock(parsingModel, nil)
            }
            catch(let parsingError)
            {
                responseProcessingBlock(nil,parsingError)
            }
        } else {
            
        }
    }
    
    
}
