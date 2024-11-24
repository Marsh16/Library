//
//  MemberView.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import SwiftUI

struct MemberView: View {
    @EnvironmentObject var memberViewModel: MemberViewModel
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
                            if memberViewModel.isLoading {
                                VStack {
                                    ProgressView()
                                }.frame(minWidth: 0, maxWidth: .infinity)
                            } else if memberViewModel.members.count == 0 {
                                VStack(spacing: 10) {
                                    Text("Still Empty Here!")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                                .padding(.top, 50)
                            } else {
                                ForEach(memberViewModel.members) { member in
                                    NavigationLink {
                                        MemberDetailView(member: member).environmentObject(memberViewModel)
                                    } label: {
                                        LazyVStack {
                                            MemberCard(member: member)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding()
                    }.sheet(isPresented: $isShowingAddMember) {
                        CreateMemberView().environmentObject(memberViewModel)
                            .environment(\.colorScheme, .light)
                    }
                }
            }
        }.onAppear{
            memberViewModel.getAllMember()
        }
    }
}
