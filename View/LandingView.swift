//
//  LandingView.swift
//  comood
//
//  Created by Valentinus on 07/04/25.
//

import SwiftUI

struct LandingView: View {
    @State private var path = NavigationPath()
    @StateObject private var profile = UserProfile()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack(spacing: 60) {
                    Image("AllEmo")
                        .resizable()
                        .frame(width: 354, height: 384.1)
                        .padding()

                    VStack(spacing: 16) {
                        Text("Track Your Mood After Work with CoMood")
                            .font(.custom("SF Pro", size: 32).weight(.bold))
                            .foregroundColor(Color.primarys)
                            .multilineTextAlignment(.center)

                        Text("CoMood helps you easily track your mood after work, offering insights to improve your emotional well-being and work-life balance.")
                            .font(.custom("SF Pro", size: 16))
                            .foregroundColor(Color.text)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: {
                    path.append("ProfileInputView")
                }) {
                    Text("Start Now")
                        .frame(maxWidth: .infinity, maxHeight: 24)
                        .padding()
                        .background(Color.primarys)
                        .foregroundColor(.white)
                        .cornerRadius(32)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationDestination(for: String.self) { value in
                switch value {
                case "ProfileInputView":
                    ProfileInputView(path: $path)
                        .environmentObject(profile)
                case "ProfilePictureView":
                    ProfilePictureView(path: $path)
                        .environmentObject(profile)
                case "HomeView":
                    MainView()
                        .environmentObject(profile)
                case "StatisticView":
                    StatisticView()
                        .environmentObject(profile)
                case "ProfileView":
                    ProfileView()
                        .environmentObject(profile)
                default:
                    EmptyView()
                }
            }
        }
    }
}


#Preview {
    LandingView()
}
