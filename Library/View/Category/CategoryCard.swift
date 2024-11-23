//
//  CategoryCard.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct CategoryCard: View {
    let name: String
    let bookCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text("\(bookCount) books")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
