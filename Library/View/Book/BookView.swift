//
//  BookView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct BookView: View {
    @EnvironmentObject var bookViewModel : BookViewModel
    @EnvironmentObject var categoryViewModel : CategoryViewModel
    @EnvironmentObject var bookCategoryViewModel : BookCategoryViewModel
    @State private var isShowingAddBook = false
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Text("Library")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                    Spacer()
                    Button(action: {
                        isShowingAddBook = true
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
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                if bookViewModel.isLoading {
                                    VStack {
                                        ProgressView()
                                    }.frame(minWidth: 0, maxWidth: .infinity)
                                }else if bookViewModel.books.count == 0 {
                                    VStack(spacing: 10) {
                                        Text("Still Empty Here!")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.top, 50)
                                }
                                else {
                                    ForEach(bookViewModel.books) { book in
                                        NavigationLink {
                                            BookDetailView(book: book).environmentObject(bookViewModel)
                                        } label: {
                                            LazyVStack {
                                                BookCard(book: book).environmentObject(categoryViewModel)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }.sheet(isPresented: $isShowingAddBook) {
                    CreateBookView().environmentObject(bookViewModel).environmentObject(categoryViewModel).environmentObject(bookViewModel)
                        .environment(\.colorScheme, .light)
                }
            }
            .onAppear {
                bookViewModel.getAllBook()
            }
        }.navigationBarBackButtonHidden()
    }
}
