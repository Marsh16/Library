//
//  HomeView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var bookViewModel = BookViewModel()
    @StateObject private var categoryViewModel = CategoryViewModel()
    @StateObject private var memberViewModel = MemberViewModel()
    @StateObject private var bookCategoryViewModel = BookCategoryViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BookView()
                .environmentObject(bookCategoryViewModel)
                .environmentObject(categoryViewModel)
                .environmentObject(bookViewModel)
                .environmentObject(memberViewModel)
                .tabItem {
                    Label("Books", systemImage: "book.fill")
                }
                .tag(0)
            
            CategoryView()
                .environmentObject(categoryViewModel)
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)
            
            MemberView()
                .environmentObject(memberViewModel)
                .tabItem {
                    Label("Members", systemImage: "person.fill")
                }
                .tag(2)
            
            BookCategoryView()
                .environmentObject(bookCategoryViewModel)
                .environmentObject(categoryViewModel)
                .environmentObject(bookViewModel)
                .environmentObject(memberViewModel)
                .tabItem {
                    Label("Book Categories", systemImage: "book.pages")
                }
                .tag(3)
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
