//
//  AppSettingsManager.swift
// WordPower
//
//  Created by Zoeb on 01/06/17.
//  Copyright (c) 2017 Alpha Solutions. All rights reserved.
//

import UIKit

class AppSettingsManager: NSObject {
    var appSettings: AppSettings
    
    static let sharedInstance = AppSettingsManager()
    
    override init() {
        appSettings = AppSettings()
        super.init()
    }
    
    func fetchSettings() -> AppSettings {
        // Find out the path of AppSettings.plist
        let path: String = Bundle.main.path(forResource: "AppSettings", ofType: "plist")!
        
        // Load the file content and initialise the AppSettings obj
        let dict: NSDictionary = NSDictionary.init(contentsOfFile: path)!
        appSettings = AppSettings.appSettingsFromDict(dict: dict)
        print(dict)
        
        return appSettings
    }
}
