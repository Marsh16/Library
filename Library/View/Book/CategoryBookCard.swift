//
//  CategoryCard.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//


import SwiftUI

struct CategoryBookCard: View {
    let name: String
    
    var body: some View {
        Text(name)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
            )
    }
}

#Preview {
    CategoryCard(name: "Action")
    CategoryCard(name: "Action")
}
