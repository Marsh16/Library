//
//  ResponseCategory.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct ResponseCategories: Codable {
    let status: Int
    let message: String
    let data: [Category]
}

struct ResponseCategory: Codable {
    let status: Int
    let message: String
    let data: Category
}


