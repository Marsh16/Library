//
//  RequiredFieldLabel.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//

import SwiftUI

struct RequiredFieldLabel: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.leading)
            Text("*")
                .foregroundColor(.red)
                .font(.subheadline)
        }
    }
}
