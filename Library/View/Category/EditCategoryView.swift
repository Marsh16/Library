//
//  EditCategoryView.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//
import SwiftUI

struct EditCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    
    @State var id: Int
    @State var name: String
    
    @State private var navToHome = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    categoryInfoSection
                    editButtonSection
                }
            }
            .navigationTitle("Edit Category")
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
            .navigationDestination(isPresented: $navToHome) {
                CategoryView().environmentObject(categoryViewModel)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// MARK: - View Extensions
private extension EditCategoryView {
    var categoryInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            FormField(title: "Name", text: $name, placeholder: "Please enter category")
        }
    }
    
    var editButtonSection: some View {
        HStack {
            Button(action: {
                if validateFields() {
                    editCategories()
                } else {
                    showAlert = true
                }
            }) {
                Text("Save Changes")
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
private extension EditCategoryView {
    func editCategories() {
        categoryViewModel.result = "Uploading"
        categoryViewModel.editCategory(
            id: String(id),
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

// MARK: - Preview
#Preview {
    EditCategoryView(
        id: 1,
        name: "Name"
    )
    .environmentObject(CategoryViewModel())
}
