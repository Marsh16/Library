//
//  LibraryApp.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//

import SwiftUI

@main
struct LibraryApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environment(\.colorScheme, .light)
        }
    }
}
