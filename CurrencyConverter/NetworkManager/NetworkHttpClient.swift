//
//  NetworkHttpClient.swift
//  CurrencyConverter
//
//  Created by Zoeb on 31/05/17.
//  Copyright (c) 2017 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper



class NetworkHttpClient: NSObject {
    
    typealias successBlock = (_ response: Any?) -> Void
    typealias failureBlock = (_ response: Any?) -> Void
    
    static let sharedInstance = NetworkHttpClient()
    
    var urlPathSubstring: String = ""
    
    override init() {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.fetchSettings()
        urlPathSubstring = appSettings.URLPathSubstring
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: BASE URL
    class func baseUrl() -> String {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.appSettings
        
        let secureConnection: String = appSettings.EnableSecureConnection ? Constants.SecureProtocol : Constants.InsecureProtocol
        if appSettings.NetworkMode == Constants.LiveEnviroment { // for live env
            return String.init(format: "%@%@", secureConnection, appSettings.ProductionURL)
        } else if appSettings.NetworkMode == Constants.StagingEnviroment { // for staging env
            return String.init(format: "%@%@", secureConnection, appSettings.StagingURL)
        } else // for local env
        {
            return String.init(format: "%@%@", secureConnection, appSettings.LocalURL)
        }
    }
    
    // MARK: API calls
    func getAPICall<T:Mappable>(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, genericResponse:T.Type, success:@escaping successBlock, failure:@escaping failureBlock) {
        performAPICall(strURL, methodType: .get, parameters: parameters, requestHeaders: headers, genericResponse: genericResponse, success: success, failure: failure)
    }
    
    func performAPICall<T:Mappable>(_ strURL : String, methodType: HTTPMethod, parameters : Dictionary<String, Any>?, requestHeaders : [String : String]?, genericResponse:T.Type, success:@escaping successBlock, failure:@escaping failureBlock){
        let completeURL:String = NetworkHttpClient.baseUrl() + Converter.ExchangeRate.Request.getUrl(path: strURL)
        Alamofire.request(completeURL, method: methodType, parameters: parameters, encoding: (methodType == .get ? URLEncoding.default : JSONEncoding.default)).responseObject { (response: DataResponse<T>) in
            
            switch response.result {
            case .success(let value):
                print(value)
                success(response)
            case .failure(let error):
                print(error.localizedDescription)
                failure(response)
            }
        }
    }
}
