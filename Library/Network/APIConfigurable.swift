//
//  APIConfigurable.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

protocol APIConfigurable {
    var baseURL: String { get }
}

class APIConfig: APIConfigurable, ObservableObject {
    let baseURL: String
    
    init() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Couldn't find Config.plist file or it is not in correct format")
        }
        
        guard let baseURL = config["baseURL"] as? String, !baseURL.isEmpty else {
            fatalError("One or more keys are missing or empty in Config.plist")
        }
        
        self.baseURL = baseURL
    }
}
