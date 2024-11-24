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
    @State private var selectedMemberId: String? = nil
    @State private var showingMemberPicker = false
    @State private var viewMode: ViewMode = .categories
    @State private var books: [Book] = []
    enum ViewMode {
        case categories
        case memberBorrowed
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .center) {
                    Text(viewMode == .categories ? "Book Categories" : "Borrowed Books")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        viewMode = viewMode == .categories ? .memberBorrowed : .categories
                        selectedCategory = nil
                        selectedMemberId = nil
                    }) {
                        Image(systemName: viewMode == .categories ? "person.circle" : "books.vertical")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 65)
                
                Divider()
                
                if viewMode == .memberBorrowed {
                    memberBorrowedView
                } else {
                    categoryView
                }
            }
            .onAppear {
                // Load initial data
                categoryViewModel.getAllCategory()
                if selectedCategory == nil {
                    loadAllBooks()
                }
            }
        }
    }
    
    private var categoryView: some View {
        VStack {
            // Category filter
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
            
            // Books grid
            ScrollView {
                if bookViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(bookViewModel.books) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                BookCard(book: book)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var memberBorrowedView: some View {
        VStack {
            // Member selector button
            Button(action: { showingMemberPicker = true }) {
                HStack {
                    Text(selectedMemberId == nil ? "Select Member" : "Member ID: \(selectedMemberId!)")
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            // Borrowed books list
            ScrollView {
                if bookViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(bookViewModel.books) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                BorrowedBookRow(book: book)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingMemberPicker) {
            MemberPickerView(selectedMemberId: $selectedMemberId)
                .environment(\.colorScheme, .light)
        }
        .onChange(of: selectedMemberId) { newValue in
            if let memberId = newValue {
                bookViewModel.getBookByMemberId(id: memberId)
            }
        }
    }
    
    private func loadAllBooks() {
        bookViewModel.getAllBook()
    }
    
    private func loadBooksByCategory(categoryId: String) {
      Task {
        bookCategoryViewModel.getBookByCategoryId(id: categoryId)
        for category in bookCategoryViewModel.bookCategories {
            bookViewModel.books = bookViewModel.books.filter { $0.id.description == category.book_id }
          }
      }
    }
}
