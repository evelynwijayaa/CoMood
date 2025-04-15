//
//  InputProfile.swift
//  comood
//
//  Created by Valentinus on 06/04/25.
//
import SwiftUI

struct ProfileInputView: View {
    
    @Binding var path: NavigationPath
    
    @EnvironmentObject var profile: UserProfile
    @AppStorage("username") var username: String = "Anonymous"
    
    @State var name: String = ""
    @State private var selectedGender: String = ""
    @State private var showAlert = false
    @FocusState private var isNameFocused: Bool

    private let genders = ["Male", "Female", "Other"]
    @Environment(\.dismiss) private var dismiss

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !selectedGender.isEmpty
    }

    var body: some View {
        VStack {
            VStack(spacing: 48) {
                VStack(spacing: 24) {
                    Image("productiveInput")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 171, height: 155)

                    Text("Welcome to CoMood!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.secondarys)

                    Text("Please Input Your Personal Information Here")
                        .font(Font.custom("SF Pro", size: 16))
                        .foregroundColor(Color.text)
                }

                VStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(Font.custom("SF Pro", size: 20))
                            .padding(.horizontal, 24)

                        TextField("Input your Full Name Here", text: $name)
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isNameFocused ? Color.primarys : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .focused($isNameFocused)
                            .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender")
                            .font(Font.custom("SF Pro", size: 16))
                            .padding(.horizontal, 24)

                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(height: 50)

                            HStack {
                                Text(selectedGender.isEmpty ? "Gender" : selectedGender)
                                    .foregroundColor(selectedGender.isEmpty ? .gray : .black)
                                    .font(.custom("SF Pro", size: 16))

                                Spacer()

                                Menu {
                                    ForEach(genders, id: \.self) { gender in
                                        Button(action: {
                                            selectedGender = gender
                                        }) {
                                            Text(gender)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                    }
                }
            }

            Spacer()

            Button(action: {
                if isFormValid {
                    username = name
                    profile.gender = selectedGender
                    print("\(username)")
                    path.append("ProfilePictureView")
                } else {
                    showAlert = true
                }
            }) {
                Text("Save Profile")
                    .frame(maxWidth: .infinity, maxHeight: 24)
                    .padding()
                    .background(Color.primarys.opacity(isFormValid ? 1 : 0.7))
                    .foregroundColor(.white)
                    .cornerRadius(32)
            }
            .padding(.horizontal)
            .alert("Please fill in your name and select a gender.", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
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
                Text("Input Personal Profile")
                    .font(Font.custom("SF Pro", size: 20).bold())
                    .foregroundColor(Color.text)
            }
        }
    }
}

#Preview {
    ProfileInputView(path: .constant(NavigationPath()))
        .environmentObject(UserProfile())
}
