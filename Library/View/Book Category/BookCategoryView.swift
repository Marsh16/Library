//
//  BookCategoryView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct BookCategoryView: View {
    @EnvironmentObject var bookCategoryViewModel: BookCategoryViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @State private var selectedCategory: String? = nil
    @State private var filteredBooks: [Book] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                Text("Book Categories")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, 65)
                
                Divider()
                
                // Category filter buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryFilterButton(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            action: {
                                selectedCategory = nil
                                loadAllBooks()
                            }
                        )
                        
                        ForEach(categoryViewModel.categories) { category in
                            CategoryFilterButton(
                                title: category.name,
                                isSelected: selectedCategory == category.name,
                                action: {
                                    selectedCategory = category.name
                                    loadBooksByCategory(categoryId: String(category.id))
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                // Books display
                ScrollView {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(filteredBooks) { book in
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    BookCard(book: book)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                categoryViewModel.getAllCategory()
                loadAllBooks()
            }
        }
    }
    
    private func loadAllBooks() {
        isLoading = true
        bookViewModel.getAllBook()
        filteredBooks = bookViewModel.books
        isLoading = false
    }
    
    private func loadBooksByCategory(categoryId: String) {
        isLoading = true
        bookCategoryViewModel.getBookByCategoryId(id: categoryId)
        if bookCategoryViewModel.bookCategories.count > 0 {
            let bookIds = Set(bookCategoryViewModel.bookCategories.map { $0.book_id })
            filteredBooks = bookViewModel.books.filter { book in
                bookIds.contains(book.id.description)
            }
            isLoading = false
        }
    }
}
