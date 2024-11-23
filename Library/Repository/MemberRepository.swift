//
//  MemberRepository.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation

class MemberRepository {
    func getAllMember(completion: @escaping ([Member]?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getAllMember") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/getAllMember")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.GET

        print("Sending request to: \(url)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching members: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(ResponseMembers.self, from: data)
                    completion(response.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func createMember(name: String, phone_number: String, email: String, birthday: String, no_ktp: String, completion: @escaping (DataCreate?) -> Void) {
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
        request.setValue(phone_number, forHTTPHeaderField: "phone_number")
        request.setValue(email, forHTTPHeaderField: "email")
        request.setValue(birthday, forHTTPHeaderField: "birthday")
        request.setValue(no_ktp, forHTTPHeaderField: "no_ktp")

        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error creating member: \(error.localizedDescription)")
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
    
    func editMember(id: String,name: String, phone_number: String, email: String, birthday: String, no_ktp: String, completion: @escaping (DataEditDelete?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/editMember") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/editMember")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.PATCH
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(id, forHTTPHeaderField: "id")
        request.setValue(name, forHTTPHeaderField: "name")
        request.setValue(phone_number, forHTTPHeaderField: "phone_number")
        request.setValue(email, forHTTPHeaderField: "email")
        request.setValue(birthday, forHTTPHeaderField: "birthday")
        request.setValue(no_ktp, forHTTPHeaderField: "no_ktp")
        
        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error editing member: \(error.localizedDescription)")
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
    
    func deleteMember(id: String, completion: @escaping (DataEditDelete?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/deleteMember") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/deleteMember")")
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
                    print("Error deleting member: \(error.localizedDescription)")
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
