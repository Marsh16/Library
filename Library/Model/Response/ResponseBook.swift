//
//  Response.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct ResponseBooks: Codable {
    let status: Int
    let message: String
    let data: [Book]
}

struct ResponseBook: Codable {
    let status: Int
    let message: String
    let data: Book
}



