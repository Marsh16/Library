//
//  MemberView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct MemberView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var isShowingAddMember = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .center) {
                    Text("Members")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                    Spacer()
                    Button(action: {
                        isShowingAddMember = true
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                    .padding([.leading, .trailing])
                }
                .padding(.horizontal)
                .padding(.top, 65)
                
                Divider()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            if bookViewModel.isLoading {
                                VStack {
                                    ProgressView()
                                }.frame(minWidth: 0, maxWidth: .infinity)
                            } else {
                                // Replace with your member list
                                ForEach(0..<5) { index in
                                    MemberCard(
                                        name: "Member \(index + 1)",
                                        email: "member\(index + 1)@example.com",
                                        borrowedBooks: Int.random(in: 0...5)
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
