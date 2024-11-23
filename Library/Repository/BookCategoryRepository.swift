//
//  BookCategoryRepository.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

class BookCategoryRepository {
    func getBookByCategoryId(id: String,completion: @escaping ([Book]?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getBookByCategoryId") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/getBookByCategoryId")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.GET

        print("Sending request to: \(url)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching book category: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(ResponseBooks.self, from: data)
                    completion(response.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func createBookCategory(book_id: String, category_id: String, completion: @escaping (DataCreate?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/createBookCategory") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/createBookCategory")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.POST
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(book_id, forHTTPHeaderField: "book_id")
        request.setValue(category_id, forHTTPHeaderField: "category_id")

        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error creating book category: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(ResponseCreate.self, from: data)
                    completion(response.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func deleteBookCategory(id: String, completion: @escaping (DataEditDelete?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/deleteBookCategory") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/deleteBookCategory")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.DELETE
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(id, forHTTPHeaderField: "id")

        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error deleting category: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(ResponseEditDelete.self, from: data)
                    completion(response.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
}
