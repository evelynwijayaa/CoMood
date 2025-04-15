//
//  Untitled.swift
//  comood
//
//  Created by Valentinus on 07/04/25.
//


import SwiftUI
import PhotosUI

struct ProfilePictureView: View {
    @AppStorage("profileImageData") private var profileImageData: Data?
    @Binding var path: NavigationPath
    @EnvironmentObject var profile: UserProfile
    @State private var selectedImage: PhotosPickerItem?
    
    @State private var isActiveToQuestion: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
    
            VStack {
                Spacer()
                
                VStack(spacing: 24) {
                    ZStack {
                        if let image = profile.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 240, height: 240)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 2))
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 240, height: 240)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    
                    PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                        Text("Choose Profile Picture Here")
                            .foregroundColor(.secondarys)
                            .font(.headline)
                    }
                    .onChange(of: selectedImage) { newItem in
                                        Task {
                                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                                               let uiImage = UIImage(data: data) {
                                                profileImageData = data
                                                profile.image = uiImage
                                            }
                                        }
                                    }
                }
                
                Spacer()
                
                NavigationLink(destination: QuestionView(), isActive: $isActiveToQuestion){
                    EmptyView()}
                
                Button(action: {
                    isActiveToQuestion = true
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity, maxHeight: 24)
                        .padding()
                        .background(Color.primarys)
                        .foregroundColor(.white)
                        .cornerRadius(32)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("back")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Upload Profile Picture")
                        .font(Font.custom("SF Pro", size: 20).bold())
                        .foregroundColor(Color.text)
                }
            }
        
    }
}

//Updated eve 9 april
#Preview {
    ProfilePictureView(path: .constant(NavigationPath()))
        .environmentObject(UserProfile())
}
