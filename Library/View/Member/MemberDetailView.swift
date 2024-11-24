//
//  MemberDetailView.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//

import SwiftUI

struct MemberDetailView: View{
    let member: Member
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var memberViewModel: MemberViewModel
    @State private var isShowingEditMember = false
    @State private var showAlert = false
    @State private var isNavHome = false

    var body: some View {
        LazyVStack {
            VStack (alignment: .leading){
                Text("Name : \(member.name)").bold().font(.headline)
                Text("\(member.email) (\(member.birthday))").font(.footnote).foregroundColor(.gray)
                Text("\(member.no_ktp) (\(member.birthday))").font(.footnote)
                Text(member.phone_number).font(.caption)
            }.padding()
            HStack(alignment: .center) {
                Button(action: {
                    isShowingEditMember = true
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
        }.sheet(isPresented: $isShowingEditMember) {
            EditMemberView(id: member.id, name: member.name, email: member.email, birthday: DateFormatter.parseFormattedDate(member.birthday)!, phone_number: member.phone_number, no_ktp: member.no_ktp).environmentObject(memberViewModel)
                .environment(\.colorScheme, .light)
                .navigationBarBackButtonHidden()
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are You Sure You Want To Delete This Book?"),primaryButton: .destructive(Text("Delete")) {
                memberViewModel.result = "Uploading"
                memberViewModel.deleteMember(id: String(member.id))
            },
                  secondaryButton: .cancel(Text("Dismiss")))
        }.onChange(of: memberViewModel.result) { newValue in
            if newValue == "Success" {
                memberViewModel.getAllMember()
                isNavHome = true
            }
        }
        .navigationDestination(isPresented: $isNavHome) {
            MemberView().environmentObject(memberViewModel)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CategoryDetailView(category: Category.categoryData.first!).environmentObject(CategoryViewModel())
}
