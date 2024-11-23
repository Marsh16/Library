//
//  MemberViewModel.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//
import Foundation

class MemberViewModel: ObservableObject{
    @Published var members = [Member]()
    @Published var member: Member = Member(id: 1, name: "", phone_number: "", email: "", birthday: "", no_ktp: "")
    @Published var isLoading = false
    @Published var result : String = ""
    
    private let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository = MemberRepository()) {
        self.memberRepository = memberRepository
    }
    
    func getAllMember() {
        isLoading = true
        memberRepository.getAllMember() { [weak self] member in
            guard let member = member else { return }
            DispatchQueue.main.async {
                self?.members = member
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func createMember(name: String, phone_number: String, email: String, birthday: String, no_ktp: String) {
        isLoading = true
        memberRepository.createMember(name: name, phone_number: phone_number, email: email, birthday: birthday, no_ktp: no_ktp) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func editMember(id: String,name: String, phone_number: String, email: String, birthday: String, no_ktp: String) {
        isLoading = true
        memberRepository.editMember(id: id,name: name, phone_number: phone_number, email: email, birthday: birthday, no_ktp: no_ktp) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
    
    func deleteMember(id: String) {
        isLoading = true
        memberRepository.deleteMember(id: id) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.result = "Success"
                self?.isLoading = false
                let _ = print("success")
            }
        }
    }
}
