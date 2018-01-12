//
//  ConverterWorker.swift
//  CurrencyConverter
//
//  Created by Apple on 12/01/18.
//  Copyright (c) 2018 Apple. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class ConverterWorker
{
    func doExchangeRateWork(request:Converter.ExchangeRate.Request, success:@escaping(CompletionHandler), fail:@escaping(CompletionHandler))
    {
        //call network etc.
        let manager = RequestManager()
        
        manager.fetchExchangeRate(request: request) { (status, response) in
            self.handleResponse(success: success, fail: fail, status: status, response: response)
        }
        
    }
    
    public func handleResponse(success:@escaping(CompletionHandler), fail:@escaping(CompletionHandler), status: Bool, response: Any?) {
        var message:String = Constants.kErrorMessage
        if status {
            if let result = response as? Converter.ExchangeRate.Response {
                success(true, result)
                return
            }
        }
        else {
            if let result = response as? Converter.ExchangeRate.Response {
                fail(false, result)
                return
            }
            else
            {
                if let result = response as? String {
                    message = result
                }
            }
        }
        fail(false, Converter.ExchangeRate.Response(message:message)!)
    }
}
