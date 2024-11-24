//
//  CategoryView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var isShowingAddCategory = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .center) {
                    Text("Categories")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                    Spacer()
                    Button(action: {
                        isShowingAddCategory = true
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                    .padding([.leading, .trailing])
                }
                .padding(.horizontal)
                .padding(.top, 65)
                
                Divider()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            if categoryViewModel.isLoading {
                                VStack {
                                    ProgressView()
                                }.frame(minWidth: 0, maxWidth: .infinity)
                            }else if categoryViewModel.categories.count == 0 {
                                VStack(spacing: 10) {
                                    Text("Still Empty Here!")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                                .padding(.top, 50)
                            } else {
                                ForEach(categoryViewModel.categories) { category in
                                    NavigationLink {
                                        CategoryDetailView(category: category).environmentObject(categoryViewModel)
                                    } label: {
                                        LazyVStack {
                                            CategoryCard(name: "\(category.name)")
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                            }
                        }
                    }
                    .padding()
                }.sheet(isPresented: $isShowingAddCategory) {
                    CreateCategoryView().environmentObject(categoryViewModel)
                        .environment(\.colorScheme, .light)
                }
            }
        }.onAppear{
            categoryViewModel.getAllCategory()
        }
    }
}
