//
//  HomeView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var bookViewModel = BookViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BookView()
                .environmentObject(bookViewModel)
                .tabItem {
                    Label("Books", systemImage: "book.fill")
                }
                .tag(0)
            
            CategoryView()
                .environmentObject(bookViewModel)
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)
            
            MemberView()
                .environmentObject(bookViewModel)
                .tabItem {
                    Label("Members", systemImage: "person.fill")
                }
                .tag(2)
            
            BookCategoryView()
                .environmentObject(bookViewModel)
                .tabItem {
                    Label("Book Categories", systemImage: "book.pages")
                }
                .tag(3)
        }
    }
}

#Preview {
    HomeView()
}
