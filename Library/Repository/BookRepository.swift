//
//  BookRepository.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import Foundation
import UIKit

class BookRepository {
    func getAllBooks(completion: @escaping ([Book]?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getAllBook") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/getAllBook")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.GET

        print("Sending request to: \(url)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
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
    
    func getBookByBookId(id: String, completion: @escaping (Book?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getBookByBookId?id=\(id)") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/getBookByBookId")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.GET

        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(ResponseBook.self, from: data)
                    completion(response.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func getBookByMemberId(id: String, completion: @escaping ([Book]?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/getBookByMemberId?id=\(id)") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/getBookByMemberId")")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.GET
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
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
    
    func createBook(title: String, synopsis: String, coverImage: UIImage, author: String, publishDate: String, memberId: String, completion: @escaping (DataCreate?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/createBook") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/createBook")")
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
        
        addTextFieldPart(name: "title", value: title)
        addTextFieldPart(name: "synopsis", value: synopsis)
        addTextFieldPart(name: "author", value: author)
        addTextFieldPart(name: "publish_date", value: publishDate)
        addTextFieldPart(name: "member_id", value: memberId)
        
        guard let resizedImage = resizeImage(image: coverImage, maxWidth: 1024),
              let imageData = resizedImage.jpegData(compressionQuality: 0.5) else {
            print("Error: Could not obtain valid image data")
            completion(nil)
            return
        }
        
        let filename = "\(UUID().uuidString.lowercased()).jpeg"
        
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"cover_image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ResponseCreate.self, from: data)
                    print(result)
                    completion(result.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func editBook(id: String, title: String, synopsis: String, coverImage: UIImage, author: String, publishDate: String, memberId: String, completion: @escaping (DataEditDelete?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/editBook") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/editBook")")
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
        addTextFieldPart(name: "title", value: title)
        addTextFieldPart(name: "synopsis", value: synopsis)
        addTextFieldPart(name: "author", value: author)
        addTextFieldPart(name: "publish_date", value: publishDate)
        addTextFieldPart(name: "member_id", value: memberId)
        
        guard let resizedImage = resizeImage(image: coverImage, maxWidth: 1024),
              let imageData = resizedImage.jpegData(compressionQuality: 0.5) else {
            print("Error: Could not obtain valid image data")
            completion(nil)
            return
        }
        
        let filename = "\(UUID().uuidString.lowercased()).jpeg"
        
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"cover_image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        print("Sending request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("No data received from the server")
                    completion(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ResponseEditDelete.self, from: data)
                    print(result)
                    completion(result.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func deleteBook(id: String, completion: @escaping (DataEditDelete?) -> Void) {
        let urlString = APIManager.shared.baseURL
        
        guard let url = URL(string: urlString + "/deleteBook") else {
            completion(nil)
            print("Invalid URL: \(urlString + "/deleteBook")")
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
                    print("Error: \(error.localizedDescription)")
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
                    let result = try JSONDecoder().decode(ResponseEditDelete.self, from: data)
                    print(result)
                    completion(result.data)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }

    // Function to resize the image
    private func resizeImage(image: UIImage, maxWidth: CGFloat) -> UIImage? {
        let size = image.size
        
        let widthRatio  = maxWidth  / size.width
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
