//
//  CategoryDetailView.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//

import SwiftUI

struct CategoryDetailView: View{
    let category: Category
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var isShowingEditCategory = false
    @State private var showAlert = false
    @State private var isNavHome = false

    var body: some View {
        LazyVStack {
            VStack (alignment: .leading){
                Text("Category : \(category.name)").bold().font(.headline)
            }.padding()
            HStack(alignment: .center) {
                Button(action: {
                    isShowingEditCategory = true
                }) {
                    Text("Edit").padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        ).padding(.horizontal)
                }
                .buttonStyle(DefaultButtonStyle())
                Button(action: {
                        showAlert = true
                }) {
                    Text("Delete").padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        ).padding(.horizontal)
                }
                .buttonStyle(DefaultButtonStyle())
            }
            .padding(.top, 75).frame(maxWidth: .infinity)
        }.sheet(isPresented: $isShowingEditCategory) {
            EditCategoryView(id: category.id, name: category.name).environmentObject(categoryViewModel)
                .environment(\.colorScheme, .light)
                .navigationBarBackButtonHidden()
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are You Sure You Want To Delete This Book?"),primaryButton: .destructive(Text("Delete")) {
                categoryViewModel.result = "Uploading"
                categoryViewModel.deleteCategory(id: String(category.id))
            },
                  secondaryButton: .cancel(Text("Dismiss")))
        }.onChange(of: categoryViewModel.result) { newValue in
            if newValue == "Success" {
                categoryViewModel.getAllCategory()
                isNavHome = true
            }
        }
        .navigationDestination(isPresented: $isNavHome) {
            CategoryView().environmentObject(categoryViewModel)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CategoryDetailView(category: Category.categoryData.first!).environmentObject(CategoryViewModel())
}
