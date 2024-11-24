//
//  CategoryRepository.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

class CategoryRepository {
    func getAllCategory(completion: @escaping ([Category]?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getAllCategory") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/getAllCategory")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.GET

        print("Sending request to: \(url)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching categories: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(ResponseCategories.self, from: data)
                    completion(response.data) 
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func createCategory(name: String, completion: @escaping (DataCreate?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/createCategory") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/createCategory")")
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
       
        addTextFieldPart(name: "name", value: name)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error creating category: \(error.localizedDescription)")
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
    
    func editCategory(id: String,name: String, completion: @escaping (DataEditDelete?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/editCategory") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/editCategory")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.PATCH
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        func addTextFieldPart(name: String, value: String) {
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value.data(using: .utf8)!)
        }
       
        addTextFieldPart(name: "id", value: id)
        addTextFieldPart(name: "name", value: name)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error editing category: \(error.localizedDescription)")
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
                    
                    let response = try JSONDecoder().decode(ResponseEditDelete.self, from: data)
                    completion(response.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func deleteCategory(id: String, completion: @escaping (DataEditDelete?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/deleteCategory") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/deleteCategory")")
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
