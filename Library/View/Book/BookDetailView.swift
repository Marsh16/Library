//
//  BookDetailView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct BookDetailView: View{
    let book: Book
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bookViewModel: BookViewModel
    @EnvironmentObject var bookCategoryViewModel: BookCategoryViewModel
    @State private var isShowingEditBook = false
    @State private var showAlert = false
    @State private var isNavHome = false
    @State private var selectedCategories : Set<Int> = []


    var body: some View {
        LazyVStack {
            VStack{
                AsyncImage(url: URL(string: book.cover_image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, maxHeight:
                                100)
                } placeholder: {
                    VStack {
                        ProgressView()
                    }.frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            VStack (alignment: .leading){
                Text(book.title).bold().font(.headline)
                Text("\(book.author) (\(book.publish_date))").font(.footnote).foregroundColor(.gray)
                Text(book.synopsis).lineLimit(3).font(.caption)
            }.padding()
            HStack(alignment: .center) {
                Button(action: {
                    isShowingEditBook = true
                }) {
                    Text("Edit").padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        ).padding(.horizontal)
                }
                .buttonStyle(DefaultButtonStyle())
                Button(action: {
                        showAlert = true
                }) {
                    Text("Delete").padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        ).padding(.horizontal)
                }
                .buttonStyle(DefaultButtonStyle())
            }
            .padding(.top, 75).frame(maxWidth: .infinity)
        }.sheet(isPresented: $isShowingEditBook) {
            EditBookView(id: book.id, title: book.title, synopsis: book.synopsis, author: book.author, publishDate: DateFormatter.parseFormattedDate(book.publish_date)!, member_id: book.member_id, coverImageURL: book.cover_image, selectedCategories: selectedCategories).environmentObject(bookViewModel)
                .environment(\.colorScheme, .light)
                .navigationBarBackButtonHidden()
        }.onAppear{
            bookCategoryViewModel.getCategoryByBookId(id: book.id.description)
            for category in bookCategoryViewModel.bookCategories {
                selectedCategories.insert(Int(category.category_id)!)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are You Sure You Want To Delete This Book?"),primaryButton: .destructive(Text("Delete")) {
                bookViewModel.result = "Uploading"
                bookViewModel.deleteBook(id: String(book.id))
            },
                  secondaryButton: .cancel(Text("Dismiss")))
        }.onChange(of: bookViewModel.result) { newValue in
            if newValue == "Success" {
                bookViewModel.getAllBook()
                isNavHome = true
            }
        }
        .navigationDestination(isPresented: $isNavHome) {
            HomeView().environmentObject(bookViewModel)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    BookDetailView(book: Book.bookData.first!).environmentObject(BookViewModel())
}
