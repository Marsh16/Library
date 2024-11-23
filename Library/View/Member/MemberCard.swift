//
//  MemberCard.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

struct MemberCard: View {
    let name: String
    let email: String
    let borrowedBooks: Int
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(borrowedBooks) books borrowed")
                    .font(.caption)
                    .foregroundColor(.blue)
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
