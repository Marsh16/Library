//
//  EditMemberView.swift
//  Library
//
//  Created by Marsha Likorawung on 24/11/24.
//

import SwiftUI

struct EditMemberView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var memberViewModel: MemberViewModel
    
    @State var id: Int
    @State var name: String
    @State var email: String
    @State var birthday: Date
    @State var phone_number: String
    @State var no_ktp: String
    @State private var isShowingDatePicker = false
    @State private var navToHome = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    memberInfoSection
                    datePickerSection
                    editButtonSection
                }
            }
            .navigationTitle("Edit Member")
            .alert("Hold Up!", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: memberViewModel.result) { newValue in
                if newValue == "Success" {
                    memberViewModel.getAllMember()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationDestination(isPresented: $navToHome) {
                MemberView().environmentObject(memberViewModel)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// MARK: - View Extensions
private extension EditMemberView {
    var memberInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            FormField(title: "Name", text: $name, placeholder: "Please enter Name")
            FormField(title: "Email", text: $email, placeholder: "Please enter Email")
            FormField(title: "Phone Number", text: $phone_number, placeholder: "Please enter Phone Number")
            FormField(title: "No KTP", text: $no_ktp, placeholder: "Please enter No KTP")
        }
    }
    
    var datePickerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RequiredFieldLabel(title: "Birthday")
            
            Button(action: { isShowingDatePicker.toggle() }) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("\(birthday, formatter: DateFormatter.dateFormatter)")
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
                    selection: $birthday,
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
                    editMembers()
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
private extension EditMemberView {
    func editMembers() {
        memberViewModel.result = "Uploading"
        memberViewModel.editMember(
            id: String(id),
            name: name,
            phone_number: phone_number,
            email: email,
            birthday: DateFormatter.dateFormatterYearComma(birthday),
            no_ktp: no_ktp
        )
    }
    
    func validateFields() -> Bool {
        if name.isEmpty {
            alertMessage = "Name is Empty!"
            return false
        }
        if phone_number.isEmpty {
            alertMessage = "phone number is Empty!"
            return false
        }
        if email.isEmpty {
            alertMessage = "email is Empty!"
            return false
        }
        if birthday.description.isEmpty {
            alertMessage = "birthday is Empty!"
            return false
        }
        
        if no_ktp.isEmpty{
            alertMessage = "no_ktp is Empty!"
            return false
        }
        alertMessage = ""
        return true
    }
}
