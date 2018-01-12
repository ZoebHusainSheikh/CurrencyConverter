//
//  RequestManager.swift
//  CurrencyConverter
//
//  Created by Zoeb on 05/06/17.
//  Copyright (c) 2017 Apple. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    //MARK: ExchangeRate API
    
    func fetchExchangeRate(request:Converter.ExchangeRate.Request, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            RealAPI().postObject(request:request, genericResponse: Token.JWTToken.Response.self, completion:completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
//            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
}
