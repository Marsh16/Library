//
//  CreateCategoryView.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//

import SwiftUI

struct CreateCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var name = ""
    @State private var navToHome = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    categoryInfoSection
                    createButtonSection
                }
            }
            .navigationTitle("Create Category")
            .alert("Hold Up!", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: categoryViewModel.result) { newValue in
                if newValue == "Success" {
                    categoryViewModel.getAllCategory()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

// MARK: - View Extensions
private extension CreateCategoryView {
    var categoryInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            FormField(title: "Name", text: $name, placeholder: "Please enter category name")
        }
    }
    
    var createButtonSection: some View {
        HStack {
            Button(action: {
                if validateFields() {
                    addCategory()
                } else {
                    showAlert = true
                }
            }) {
                Text("Create")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
        }
        .padding(.top, 75)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Helper Methods
private extension CreateCategoryView {
    func addCategory() {
        categoryViewModel.result = "Uploading"
        categoryViewModel.createCategory(
            name: name
        )
    }
    
    func validateFields() -> Bool {
        if name.isEmpty {
            alertMessage = "Name is Empty!"
            return false
        }
        alertMessage = ""
        return true
    }
}

#Preview {
    CreateBookView()
        .environmentObject(BookViewModel())
}
