//
//  MemberPickerView.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//
import SwiftUI

struct MemberPickerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var memberViewModel: MemberViewModel
    @Binding var selectedMemberId: String?
    
    var body: some View {
        NavigationView {
            List(memberViewModel.members) { member in
                Button(action: {
                    selectedMemberId = String(member.id)
                    dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text(member.name)
                            .font(.headline)
                        Text("ID: \(member.id)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Select Member")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .onAppear {
                memberViewModel.getAllMember()
            }
        }
    }
}
