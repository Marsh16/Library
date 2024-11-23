//
//  CategoryViewModel.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

class CategoryViewModel: ObservableObject{
    @Published var categories = [Category]()
    @Published var category: Category = Category(id: 1, name: "")
    @Published var isLoading = false
    @Published var result : String = ""
    
    private let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository = CategoryRepository()) {
        self.categoryRepository = categoryRepository
    }
    
    func getAllCategory() {
        isLoading = true
        categoryRepository.getAllCategory() { [weak self] category in
            guard let category = category else { return }
            DispatchQueue.main.async {
                self?.categories = category
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func createCategory(name: String) {
        isLoading = true
        categoryRepository.createCategory(name: name) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func editCategory(id: String,name: String) {
        isLoading = true
        categoryRepository.editCategory(id: id, name: name) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func deleteCategory(id: String) {
        isLoading = true
        categoryRepository.deleteCategory(id: id) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
}
