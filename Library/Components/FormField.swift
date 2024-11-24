//
//  FormField.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//

import SwiftUI

// MARK: - Supporting Views
struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            RequiredFieldLabel(title: title)
            
            TextField(placeholder, text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }
}
