//
//  BookCategoryView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct BookCategoryView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var selectedCategory: String? = nil
    @State private var isShowingAddBook = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack(alignment: .center) {
                    Text("Book Categories")
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
                
                // Category Filter Scrollview
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryFilterButton(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil }
                        )
                        
                        // Replace with your actual categories
                        ForEach(["Fiction", "Non-Fiction", "Science", "History", "Art"], id: \.self) { category in
                            CategoryFilterButton(
                                title: category,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding()
                }
                
                // Books List
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if bookViewModel.isLoading {
                                VStack {
                                    ProgressView()
                                }.frame(minWidth: 0, maxWidth: .infinity)
                            } else {
                                // Group books by category
                                ForEach(getCategories(), id: \.self) { category in
                                    CategorySection(
                                        category: category,
                                        books: bookViewModel.books
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $isShowingAddBook) {
                CreateBookView()
                    .environmentObject(bookViewModel)
                    .environment(\.colorScheme, .light)
            }
        }
    }
    
    // Helper functions
    private func getCategories() -> [String] {
        // If a category is selected, only show that category
        if let selectedCategory {
            return [selectedCategory]
        }
        // Replace with actual category fetch logic
        return ["Fiction", "Non-Fiction", "Science", "History", "Art"]
    }
//    
//    private func getBooksForCategory(_ category: String) -> [Book] {
//        // Replace with actual filtered books logic
//
//        return bookCategoryViewModel.books.filter { $0 == category }
//    }
}

// MARK: - Supporting Views
struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct CategorySection: View {
    let category: String
    let books: [Book]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(books) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            BookCardHorizontal(book: book)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct BookCardHorizontal: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading) {
            // Book Cover Image
            AsyncImage(url: URL(string:book.cover_image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 120, height: 180)
            .cornerRadius(8)
            
            
            // Book Info
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(book.author)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(width: 120)
        }
    }
}
