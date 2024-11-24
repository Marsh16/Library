//
//  EditBookView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bookViewModel: BookViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @EnvironmentObject var bookCategoryViewModel: BookCategoryViewModel
    @EnvironmentObject var memberViewModel: MemberViewModel
    
    @State var id: Int
    @State var title: String
    @State var synopsis: String
    @State var author: String
    @State var publishDate: Date
    @State var coverImage: UIImage?
    @State var member_id: String?
    @State var coverImageURL: String
    @State var selectedCategories: Set<Int>
    
    @State private var showingMemberPicker = false
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
                    categorySection
                    memberSection
                    datePickerSection
                    editButtonSection
                }
            }
            .navigationTitle("Edit Book")
            .alert("Hold Up!", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: bookViewModel.result) { newValue in
                if newValue == "Success" {
                    createBookCategories()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onChange(of: bookCategoryViewModel.result) { newValue in
                if newValue == "Success" {
                    bookViewModel.getAllBook()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .sheet(isPresented: $showingMemberPicker) {
                MemberPickerView(selectedMemberId: $member_id)
                    .environment(\.colorScheme, .light)
            }
            }
            .onChange(of: member_id) { newValue in
            if let memberId = newValue {
                member_id = memberId
            }
            }
            .navigationDestination(isPresented: $navToHome) {
                HomeView().environmentObject(bookViewModel)
                    .navigationBarBackButtonHidden(true)
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
            .onAppear {
                categoryViewModel.getAllCategory()
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
    
    var memberSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RequiredFieldLabel(title: "Member")
            Button(action: { showingMemberPicker = true }) {
                HStack {
                        Text(member_id == nil ? "Select Member" : "Member ID: \(member_id!)")
                        Spacer()
                        Image(systemName: "chevron.down")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }.padding(.horizontal)
        }
    }
    
    private func toggleCategory(_ categoryId: Int) {
        if selectedCategories.contains(categoryId) {
            selectedCategories.remove(categoryId)
        } else {
            selectedCategories.insert(categoryId)
        }
    }
    
    private func createBookCategories() {
        bookViewModel.getAllBook()
        let existingCategoryIDs = Set(bookCategoryViewModel.bookCategories.map { $0.id })
        
        for categoryId in selectedCategories {
            if !existingCategoryIDs.contains(categoryId) {
                bookCategoryViewModel.createBookCategory(
                    book_id: id.description,
                    category_id: String(categoryId)
                )
            }
        }
        print("added book categories")
    }
    
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RequiredFieldLabel(title: "Categories")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categoryViewModel.categories) { category in
                        CategoryChip(
                            title: category.name,
                            isSelected: selectedCategories.contains(category.id),
                            action: {
                                toggleCategory(category.id)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            if !selectedCategories.isEmpty {
                Text("Selected: \(selectedCategories.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
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
        if let coverImage, let member_id {
            bookViewModel.result = "Uploading"
            bookViewModel.editBook(
                id: String(id),
                title: title,
                synopsis: synopsis,
                coverImage: coverImage,
                author: author,
                publishDate: DateFormatter.dateFormatterYearComma(publishDate),
                memberId: member_id
            )
        }else{
            do {
                let url = URL(string: coverImageURL)!
                let data = try Data(contentsOf: url)
                let myImage = UIImage(data: data)
                if let myImage, let member_id {
                    bookViewModel.result = "Uploading"
                    bookViewModel.editBook(
                        id: String(id),
                        title: title,
                        synopsis: synopsis,
                        coverImage: myImage,
                        author: author,
                        publishDate: DateFormatter.dateFormatterYearComma(publishDate),
                        memberId: member_id
                    )
                }
            } catch {
                    print("Error: \(error)")
                }
            
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
        if let member_id{
            if member_id.isEmpty {
                alertMessage = "Please select member!"
                return false
            }
        }
        if selectedCategories.count == 0{
            alertMessage = "Please select category!"
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
        member_id: "1",
        coverImageURL: "Sample Image", selectedCategories: [1, 2, 3]
    )
    .environmentObject(BookViewModel())
}
