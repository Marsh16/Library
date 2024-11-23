//
//  ResponseCreate.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct ResponseCreate: Codable {
    let status: Int
    let message: String
    let data: DataCreate
}

struct DataCreate: Codable {
    let lastInsertedID: Int

    enum CodingKeys: String, CodingKey {
        case lastInsertedID = "last_inserted_id"
    }
}
