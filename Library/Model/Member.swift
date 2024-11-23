//
//  Member.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct Member: Codable, Identifiable {
    let id : Int
    let name: String
    let phone_number: String
    let email: String
    let birthday: String
    let no_ktp: String
}
