//
//  Book.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct Book: Codable, Identifiable {
    let id : Int
    let title: String
    let synopsis: String
    let cover_image: String
    let author: String
    let publish_date: String
    let member_id: String
}
