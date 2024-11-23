//
//  ScanBillPopup.swift
//  Library
//
//  Created by Marsha Likorawung on 23/11/24.
//


import SwiftUI

struct BookImagePopup: View {
    @Binding var isImagePicker: Bool
    @Binding var isCamera: Bool
    @Binding var isLibrary: Bool

    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Color(white: 0, opacity: 0.75)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isImagePicker = false
                    }
                VStack(spacing: 16) {
                    Button(action: {
                        isImagePicker = false
                    }) {
                        HStack{
                            Spacer()
                            Image(systemName: "x.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Button(action: {
                        isCamera = true
                        isLibrary = false
                        isImagePicker = false

                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Take Photo")
                        }
                    }
                    .buttonStyle(SecondaryButton())
                    .padding(.horizontal)
                    
                    
                    Button(action: {
                        isCamera = false
                        isLibrary = true
                        isImagePicker = false

                    }) {
                        HStack {
                            Image(systemName: "photo.fill")
                            Text("Upload From Gallery")
                        }
                    }
                    .buttonStyle(BorderedButton())
                    .padding(.bottom, 35)
                }
                .padding(.trailing, 5)
                .padding(.top, 5)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding(.horizontal, 50)
            }
        }
    }
}
