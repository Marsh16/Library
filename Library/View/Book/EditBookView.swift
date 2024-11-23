//
//  EditBookView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

// MARK: - Main View
struct EditBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @State var id: Int
    @State var title: String
    @State var synopsis: String
    @State var author: String
    @State var publishDate: Date
    @State var coverImage: UIImage?
    @State var memberId: String
    @State var coverImageURL: String
    
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
                    editButtonSection
                }
            }
            .navigationTitle("Edit Book")
            .onAppear {
                if bookViewModel.result == "Success" {
                    bookViewModel.getAllBook()
                    presentationMode.wrappedValue.dismiss()
                }
            }
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
private extension EditBookView {
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
            }else{
                if !coverImageURL.isEmpty {
                    VStack {
                        AsyncImage(url: URL(string: coverImageURL)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .cornerRadius(10)
                        } placeholder: {
                            VStack {
                                VStack {
                                    ProgressView()
                                }.frame(minWidth: 0, maxWidth: .infinity)
                            }.frame(minWidth: 0, maxWidth: .infinity)
                        }
                    }
                }
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
    
    var editButtonSection: some View {
        HStack {
            Button(action: {
                if validateFields() {
                    editBooks()
                } else {
                    showAlert = true
                }
            }) {
                Text("Save Changes")
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

// MARK: - Helper Methods
private extension EditBookView {
    func editBooks() {
        if let coverImage {
            bookViewModel.result = "Uploading"
            bookViewModel.editBook(
                id: String(id),
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
        
        if coverImageURL.isEmpty{
            alertMessage = "Cover image is Empty!"
            return false
        }
        
        alertMessage = ""
        return true
    }
}

// MARK: - Preview
#Preview {
    EditBookView(
        id: 1,
        title: "Sample Book",
        synopsis: "Sample Synopsis",
        author: "Sample Author",
        publishDate: Date(),
        memberId: "1",
        coverImageURL: "Sample Image"
    )
    .environmentObject(BookViewModel())
}
