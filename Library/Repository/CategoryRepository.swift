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
        request.setValue(name, forHTTPHeaderField: "name")

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
        request.setValue(id, forHTTPHeaderField: "id")
        request.setValue(name, forHTTPHeaderField: "name")

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
