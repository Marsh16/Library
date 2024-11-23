//
//  ResponseMember.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct ResponseMembers: Codable {
    let status: Int
    let message: String
    let data: [Member]
}

struct ResponseMember: Codable {
    let status: Int
    let message: String
    let data: Member
}


