//
//  ResponseCreate 2.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct ResponseEditDelete: Codable {
    let status: Int
    let message: String
    let data: DataEditDelete
}

struct DataEditDelete: Codable {
    let rowsAffected: Int

    enum CodingKeys: String, CodingKey {
        case rowsAffected = "rows_affected"
    }
}

