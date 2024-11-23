//
//  ResponseBookCategory.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct ResponseBookCategories: Codable {
    let status: Int
    let message: String
    let data: [BookCategory]
}

struct ResponseBookCategory: Codable {
    let status: Int
    let message: String
    let data: BookCategory
}
