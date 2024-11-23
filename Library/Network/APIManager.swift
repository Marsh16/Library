//
//  APIManager.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let config: APIConfigurable

    init(config: APIConfigurable = APIConfig()) {
        self.config = config
    }

    lazy var baseURL = config.baseURL
}
