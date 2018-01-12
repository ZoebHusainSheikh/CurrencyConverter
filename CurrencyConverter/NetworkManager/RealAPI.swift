//
//  RealAPI.swift
//  CurrencyConverter
//
//  Created by Zoeb on 01/06/17.
//  Copyright (c) 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class RealAPI: NSObject {
    
    var realAPIBlock: CompletionHandler = { _,_ in }
    
    func getObject<T:Mappable>(request: Converter.ExchangeRate.Request, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithGetObject(request: request, genericResponse: genericResponse, completion: completion)
    }
    
    // MARK: Request methods
    func interactAPIWithGetObject<T:Mappable>(request: Converter.ExchangeRate.Request, genericResponse:T.Type, completion: @escaping CompletionHandler) -> Void {
        NetworkHttpClient.sharedInstance.getAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, genericResponse: genericResponse, success: { (responseObject) in
            self.handleSuccessResponse(response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject as? DataResponse<T>, responseArray: responseObject as? DataResponse<[T]>, block: completion)
        })
    }
    
    //Handling success response
    func handleSuccessResponse<T:Mappable>(response: DataResponse<T>?, responseArray: DataResponse<[T]>?, block:@escaping CompletionHandler) -> Void {
        let responseStatus = response != nil ? response?.response : responseArray?.response
        
        let message: String = String.init(format: "Success:- URL:%@\n", (responseStatus?.url?.absoluteString)!)
        print(message)
        
        if responseStatus?.statusCode == Constants.ResponseStatusSuccess || responseStatus?.statusCode == Constants.ResponseStatusCreated {
            if response != nil || responseArray != nil {
                let value = getResultValue(response: response, responseArray: responseArray)
                if let result = value {
                    block(true, result)
                }
                return
            }
        }
        else{
            if response != nil || responseArray != nil {
                let value = getResultValue(response: response, responseArray: responseArray)
                if let result = value {
                    block(false, result)
                    return
                }
            }
        }
        
        block(false, nil)
    }
    
    func getResultValue<T:Mappable>(response: DataResponse<T>?, responseArray: DataResponse<[T]>?) -> Any? {
        var value:Any?
        
        if response != nil {
            value = response?.result.value
        }
        else if responseArray != nil {
            value = responseArray?.result.value
        }
        
        return value
    }
    
    //Handling Error response
    func handleError<T:Mappable>(response: DataResponse<T>?, responseArray: DataResponse<[T]>?, block: @escaping CompletionHandler) -> Void {
        let responseStatus = response != nil ? response?.response : responseArray?.response
        
        var errorResponse: Any?
        
        let error : Error? =  response != nil ? response?.result.error! : responseArray?.result.error!
        
        let detailedError: NSError = error! as NSError
        if detailedError.localizedRecoverySuggestion != nil {
            do {
                errorResponse = try JSONSerialization.jsonObject(with: (detailedError.localizedRecoverySuggestion?.data(using: String.Encoding.utf8))!, options: JSONSerialization.ReadingOptions.mutableContainers)
                errorResponse != nil ? block(false, errorResponse) : block(false, error)
            }
            catch _ {
                // Error handling
            }
        }
        else {
            block(false, detailedError.localizedDescription)
        }
    }
}
