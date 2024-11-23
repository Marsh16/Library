//
//  ButtonStyle.swift
//  SplitBill
//
//  Created by Marsha Likorawung on 15/10/24.
//

import SwiftUI

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .font(.subheadline)
            .fontWeight(.medium)
            .frame(maxWidth: 250)
            .frame(maxHeight: 35)
            .foregroundColor(Color.black)
            .background(
                RoundedRectangle(
                    cornerRadius: 30,
                    style: .continuous
                )
                .fill(Color.white)
            )
    }
}

struct BorderedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .font(.subheadline)
            .fontWeight(.medium)
            .frame(maxWidth: 250)
            .frame(maxHeight: 35)
            .foregroundColor(Color.black)
            .background(
                RoundedRectangle(
                    cornerRadius: 30,
                    style: .continuous
                )
                .fill(Color.white)
                .stroke(Color.white, lineWidth: 1)
            )
    }
}
