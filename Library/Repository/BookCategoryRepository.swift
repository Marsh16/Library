//
//  BookCategoryRepository.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

class BookCategoryRepository {
    func getBookByCategoryId(id: String,completion: @escaping ([BookCategory]?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getBookByCategoryId?id=\(id)") else {
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
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(jsonString)")
                    }
                    let response = try JSONDecoder().decode(ResponseBookCategories.self, from: data)
                    completion(response.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func getCategoryByBookId(id: String,completion: @escaping ([BookCategory]?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getCategoryByBookId?id=\(id)") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/getCategoryByBookId")")
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
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(jsonString)")
                    }
                    let response = try JSONDecoder().decode(ResponseBookCategories.self, from: data)
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
        
        var body = Data()
        
        func addTextFieldPart(name: String, value: String) {
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value.data(using: .utf8)!)
        }
       
        addTextFieldPart(name: "book_id", value: book_id)
        addTextFieldPart(name: "category_id", value: category_id)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
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
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(jsonString)")
                    }
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
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(id)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body


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
