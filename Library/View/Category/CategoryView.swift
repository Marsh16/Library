//
//  CategoryView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
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
                            if bookViewModel.isLoading {
                                VStack {
                                    ProgressView()
                                }.frame(minWidth: 0, maxWidth: .infinity)
                            } else {
                                // Replace with your category list
                                ForEach(0..<5) { index in
                                    CategoryCard(name: "Category \(index + 1)", bookCount: Int.random(in: 1...20))
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
