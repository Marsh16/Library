//
//  BorrowedBookRow.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//

import SwiftUI

struct BorrowedBookRow: View {
    let book: Book
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: book.cover_image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(book.title)
                    .font(.headline)
                
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Published: \(book.publish_date)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
