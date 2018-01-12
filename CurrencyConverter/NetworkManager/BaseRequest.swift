////
////  Request.swift
////  CurrencyConverter
////
////  Created by Zoeb on 29/05/17.
////  Copyright (c) 2017 Apple. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//class BaseRequest: NSObject {
//    static let hasArrayResponse = "HasArrayResponse"
//
//    var urlPath: String
//    var requestType: NSInteger
//    var fileData: Data
//    var dataFilename: String
//    var fileName: String
//    var mimeType: String
//    var headers: [String: String]?
//    var parameters: Dictionary<String, Any>
//
//    override init() {
//        urlPath = ""
//        requestType = 0
//        fileData = Data()
//        dataFilename = ""
//        fileName = ""
//        mimeType = ""
//        parameters = [:]
//        super.init()
//    }
//
//    public func getParams() -> Dictionary<String, Any> {
//        return parameters
//    }
//
//    public class func getUrl(path: String) -> String {
//        let client: NetworkHttpClient = NetworkHttpClient.sharedInstance
//        return String.init(format: "%@%@",client.urlPathSubstring, path)
//    }
//}

