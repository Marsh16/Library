//
//  BookCard.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

struct BookCard: View{
    let book: Book
    var body: some View {
        LazyVStack {
            HStack {
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
                }
            }.padding()
        }.background(.white).cornerRadius(10).padding()
    }
}

#Preview {
    ForEach(Book.bookData) { book in
        BookCard(book: book)
    }
}