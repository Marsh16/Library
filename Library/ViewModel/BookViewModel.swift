//
//  BookViewModel.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation
import UIKit

class BookViewModel: ObservableObject{
    @Published var books = [Book]()
    @Published var book: Book = Book(id: 1, title: "", synopsis: "", cover_image: "", author: "", publish_date: "", member_id: "")
    @Published var isLoading = false
    @Published var result : String = ""

    private let bookRepository: BookRepository
    
    init(bookRepository: BookRepository = BookRepository()) {
        self.bookRepository = bookRepository
    }
    
    func getAllBook() {
        isLoading = true
        bookRepository.getAllBooks() { [weak self] book in
            guard let book = book else { return }
            DispatchQueue.main.async {
                self?.books = book
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func getBookByBookId(id: String) {
        isLoading = true
        bookRepository.getBookByBookId(id: id) { [weak self] book in
            guard let book = book else { return }
            DispatchQueue.main.async {
                self?.book = book
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func getBookByMemberId(id: String) {
        isLoading = true
        bookRepository.getBookByMemberId(id: id) { [weak self] book in
            guard let book = book else { return }
            DispatchQueue.main.async {
                self?.books = book
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func createBook(title: String, synopsis: String, coverImage: UIImage, author: String, publishDate: String, memberId: String) {
        isLoading = true
        bookRepository.createBook(title: title, synopsis: synopsis, coverImage: coverImage, author: author, publishDate: publishDate, memberId: memberId) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func editBook(id: String, title: String, synopsis: String, coverImage: UIImage, author: String, publishDate: String, memberId: String) {
        isLoading = true
        bookRepository.editBook(id: id,title: title, synopsis: synopsis, coverImage: coverImage, author: author, publishDate: publishDate, memberId: memberId) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func deleteBook(id: String) {
        isLoading = true
        bookRepository.deleteBook(id: id) { [weak self] book in
            guard let book = book else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
}
