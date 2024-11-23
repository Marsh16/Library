//
//  BookCategory.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

struct BookCategory: Codable, Identifiable {
    let id : Int
    let book_id: String
    let category_id: String
}
