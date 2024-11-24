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
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @EnvironmentObject var bookCategoryViewModel: BookCategoryViewModel
    @EnvironmentObject var memberViewModel: MemberViewModel
    
    @State private var title = ""
    @State private var synopsis = ""
    @State private var author = ""
    @State private var publishDate = Date()
    @State private var coverImage: UIImage?
    @State private var selectedCategories: Set<Int> = []
    @State private var member_id = ""
    
    @State private var selectedMemberId: String? = nil
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
                    categorySection
                    imageSection
                    memberSection
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
                MemberPickerView(selectedMemberId: $selectedMemberId)
                    .environment(\.colorScheme, .light)
            }
            .onChange(of: selectedMemberId) { newValue in
                if let memberId = newValue {
                    member_id = memberId
                }
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
    
    // Category selection section
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
    
    // Reuse existing sections...
    var bookInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            FormField(title: "Name", text: $title, placeholder: "Please enter book title")
            FormField(title: "Synopsis", text: $synopsis, placeholder: "Please enter book synopsis")
            FormField(title: "Author", text: $author, placeholder: "Please enter book author")
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
    
    var memberSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RequiredFieldLabel(title: "Member")
            Button(action: { showingMemberPicker = true }) {
                HStack {
                    Text(selectedMemberId == nil ? "Select Member" : "Member ID: \(selectedMemberId!)")
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
    
    // Helper functions
    private func toggleCategory(_ categoryId: Int) {
        if selectedCategories.contains(categoryId) {
            selectedCategories.remove(categoryId)
        } else {
            selectedCategories.insert(categoryId)
        }
    }
    
    private func createBookCategories() {
        bookViewModel.getAllBook()
        for categoryId in selectedCategories {
            bookCategoryViewModel.createBookCategory(
                book_id: bookViewModel.books.last!.id.description,
                category_id: String(categoryId)
            )
        }
    }
    
    private func validateFields() -> Bool {
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
        if selectedCategories.isEmpty {
            alertMessage = "Please select at least one category!"
            return false
        }
        if member_id.isEmpty {
            alertMessage = "Please select member!"
            return false
        }
        
        if selectedCategories.count == 0{
            alertMessage = "Please select category!"
            return false
        }
        
        alertMessage = ""
        return true
    }
    
    private func addBook() {
        if let coverImage {
            bookViewModel.result = "Uploading"
            bookViewModel.createBook(
                title: title,
                synopsis: synopsis,
                coverImage: coverImage,
                author: author,
                publishDate: DateFormatter.dateFormatterYearComma(publishDate),
                memberId: member_id
            )
        }
    }
}

// Category Chip View
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}
