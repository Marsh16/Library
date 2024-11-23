//
//  BookCategoryViewModel.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import UIKit

class BookCategoryViewModel: ObservableObject{
    @Published var books = [Book]()
    @Published var bookCategories = [BookCategory]()
    @Published var bookCategory: BookCategory = BookCategory(id: 1, book_id: "", category_id: "")
    @Published var isLoading = false
    @Published var result : String = ""
    
    private let bookCategoryRepository: BookCategoryRepository
    
    init(bookCategoryRepository: BookCategoryRepository = BookCategoryRepository()) {
        self.bookCategoryRepository = bookCategoryRepository
    }
    
    func getBookByMemberId(id: String) {
        isLoading = true
        bookCategoryRepository.getBookByCategoryId(id: id) { [weak self] book in
            guard let book = book else { return }
            DispatchQueue.main.async {
                self?.books = book
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func createBookCategory(book_id: String, category_id: String) {
        isLoading = true
        bookCategoryRepository.createBookCategory(book_id: book_id, category_id: category_id) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func deleteBookCategory(id: String) {
        isLoading = true
        bookCategoryRepository.deleteBookCategory(id: id) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
}
