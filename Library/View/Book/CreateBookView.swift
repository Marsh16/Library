//
//  CreateBook.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct CreateBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @State private var title = ""
    @State private var synopsis = ""
    @State private var author = ""
    @State private var publishDate = Date()
    @State private var coverImage: UIImage?
    
    @State private var isShowingDatePicker = false
    @State private var isImagePicker = false
    @State private var isCamera = false
    @State private var isLibrary = false
    @State private var navToHome = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    bookInfoSection
                    imageSection
                    datePickerSection
                    createButtonSection
                }
            }
            .navigationTitle("Create Books")
            .alert("Hold Up!", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .navigationDestination(isPresented: $isCamera) {
                CameraPickerView(selectedImage: $coverImage, navToConfirmation: $navToHome)
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $isLibrary) {
                LibraryPickerView(selectedImage: $coverImage, navToConfirmation: $navToHome)
                    .navigationBarBackButtonHidden(true)
            }
            .overlay(
                BookImagePopup(isImagePicker: $isImagePicker, isCamera: $isCamera, isLibrary: $isLibrary)
                    .opacity(isImagePicker ? 1 : 0)
            )
        }
    }
}

// MARK: - View Extensions
private extension CreateBookView {
    var bookInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            FormField(title: "Name", text: $title, placeholder: "Please enter book title")
            FormField(title: "Synopsis", text: $synopsis, placeholder: "Please enter book synopsis")
            FormField(title: "Author", text: $author, placeholder: "Please enter book author")
        }
    }
    
    var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RequiredFieldLabel(title: "Cover Image")
            
            Button(action: {
                isImagePicker = true
                isCamera = false
                navToHome = false
                isLibrary = false
            }) {
                Text("Pick Image")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            if let coverImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .cornerRadius(10)
            }
        }
    }
    
    var datePickerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RequiredFieldLabel(title: "Publish Date")
            
            Button(action: { isShowingDatePicker.toggle() }) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("\(publishDate, formatter: DateFormatter.dateFormatter)")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                    Image(systemName: isShowingDatePicker ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
            .padding(.horizontal)
            
            if isShowingDatePicker {
                DatePicker(
                    "",
                    selection: $publishDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.horizontal)
            }
        }
    }
    
    var createButtonSection: some View {
        HStack {
            Button(action: {
                if validateFields() {
                    addBook()
                } else {
                    showAlert = true
                }
            }) {
                Text("Create")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
        }
        .padding(.top, 75)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Supporting Views
struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            RequiredFieldLabel(title: title)
            
            TextField(placeholder, text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }
}

struct RequiredFieldLabel: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.leading)
            Text("*")
                .foregroundColor(.red)
                .font(.subheadline)
        }
    }
}

// MARK: - Helper Methods
private extension CreateBookView {
    func addBook() {
        if let coverImage {
            bookViewModel.result = "Uploading"
            bookViewModel.createBook(
                title: title,
                synopsis: synopsis,
                coverImage: coverImage,
                author: author,
                publishDate: DateFormatter.formatDate(publishDate),
                memberId: "1"
            )
        }
        
        if bookViewModel.result == "Success" {
            bookViewModel.getAllBook()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func validateFields() -> Bool {
        if title.isEmpty {
            alertMessage = "Title is Empty!"
            return false
        }
        if synopsis.isEmpty {
            alertMessage = "Synopsis is Empty!"
            return false
        }
        if author.isEmpty {
            alertMessage = "Author is Empty!"
            return false
        }
        if publishDate.description.isEmpty {
            alertMessage = "Published Date is Empty!"
            return false
        }
        if coverImage == nil {
            alertMessage = "Cover image is Empty!"
            return false
        }
        
        alertMessage = ""
        return true
    }
}

#Preview {
    CreateBookView()
        .environmentObject(BookViewModel())
}
