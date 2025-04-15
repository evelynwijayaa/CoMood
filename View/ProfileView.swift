//
//  ProfileView.swift
//  Trial
//
//  Created by Evelyn Wijaya on 29/03/25.
//

import SwiftUI

// MARK: - Views

struct ProfileView: View {
    // MARK: Properties
    @State private var isLightMode = false
    @State private var showDeleteConfirmation = false
    @State private var showLogOutConfirmation = false
    
    @State private var isDelete: Bool = false
    @State private var isLogOut: Bool = false
    
    @AppStorage("username") var username: String = "Anonymous"
    @AppStorage("profileImageData") private var profileImageData: Data?
    
    // MARK: Body
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                backgroundView
                VStack(spacing: 12) {
                    profileHeaderView
                    VStack (spacing:12){
                        streakBannerView
                        streakCardsView
                        settingsView
                    }
                }
                .padding(.bottom,110)
                .padding(.horizontal,16)
                
                // Popup overlay
                if showDeleteConfirmation {
                    ZStack {
                        overlayView

                        deleteConfirmationPopup
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle()) // optional, bantu interaksi tap di luar popup
                            .transition(.scale)
                            .zIndex(1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                }
                if showLogOutConfirmation {
                    ZStack {
                        overlayView
                        LogOutfirmationView(isPresented: $showLogOutConfirmation, onLogOut: handleLogout)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                            .transition(.scale)
                            .zIndex(1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                }


            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .animation(.easeInOut(duration: 0.2), value: showDeleteConfirmation)
        }
    }
    
    // MARK: UI Components
    private var backgroundView: some View {
        Image("backgroundProfile")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .ignoresSafeArea()
            .offset(y: 72)
    }
    
    private var profileHeaderView: some View {
        ZStack{
            
            VStack(spacing: 12) {
                if let data = profileImageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .background(Color.white)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 1)
                } else {
                    Image("profile") // default image
                        .resizable()
                        .background(Color.white)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 1)
                }
                
                Text("\(username)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.background)
            }
            Button(action: {}) {
                Image(systemName: "pencil")
                    .foregroundColor(Color.primarys)
                    .frame(maxWidth: 16, maxHeight: 16)
                    .padding(8)
                    .background(Color.background)
                    .clipShape(Circle())
            } .offset(x: 40, y: 30)
        }
        
    }
    
    private var streakBannerView: some View {
        HStack(alignment: .center) {
            Text("🔥 Highest right now, keep going!!")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.background)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
    
    private var streakCardsView: some View {
        HStack(spacing: 12) {
            currentStreakCard
            highestStreakCard
        }
        .padding(.horizontal, 24)
    }
    
    private var currentStreakCard: some View {
        HStack(spacing: 12) {
            Image("streakIcon")
                .resizable()
                .frame(width: 40, height: 30)
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("24")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Current Streak")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: 73, alignment: .leading)
        .background(Color.background)
        .cornerRadius(16)
    }
    
    private var highestStreakCard: some View {
        HStack(spacing: 12) {
            Image("highestStreak")
                .resizable()
                .frame(width: 40, height: 30)
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("24")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Highest Streak")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: 73, alignment: .leading)
        .background(Color.background)
        .cornerRadius(16)
    }
    
    private var settingsView: some View {
        VStack(spacing: 24) {
            Text("More Settings")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.background)
            
            VStack(spacing: 16) {
                SettingsRowView(iconName: "notifIcon", title: "Notifications", destination: NotificationSettingsView())
                
                Button(action: {
                    //
                }) {
                    SettingsToggleRowView(iconName: "displayIcon", title: "Light Mode", isOn: $isLightMode)
                        
                    }
                
                Button(action: {
                    showLogOutConfirmation = true
                }) {
                    HStack(alignment: .center) {
                        HStack(spacing: 12) {
                            Image("outIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("Log Out")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.blue)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 0.22, green: 0.49, blue: 0.85))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    HStack(alignment: .center) {
                        HStack(spacing: 12) {
                            Image("deleteIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("Delete Account")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.pink)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 0.86, green: 0.16, blue: 0.54))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(red: 0.99, green: 0.95, blue: 0.97))
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var overlayView: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                showDeleteConfirmation = false
            }
    }
    
    private var deleteConfirmationPopup: some View {
        DeleteConfirmationView(isPresented: $showDeleteConfirmation, onDelete: handleDeleteAccount)
            .transition(.scale)
            .padding(.horizontal, 36)
        
    }
    
    // MARK: Action Methods
    private func handleEditProfile() {
        // Implementasi untuk edit profile
    }
    
    private func handleLogout() {
        // Implementasi untuk logout
    }
    
    
    private func handleDeleteAccount() {
        // Implementasi untuk delete account
        print("Account deletion initiated")
        
    }
}
// MARK: - Log Out Pop Up

struct LogOutfirmationView: View {
    @Binding var isPresented: Bool
    var onLogOut: () -> Void
    

    var body: some View {
        VStack(spacing: 20) {
            corgiImage
            VStack (spacing: 12){
                confirmationText
                buttonOptions
            }

        } .frame(maxWidth: 323, maxHeight: 374)
        .padding(24)
        .background(Color.background)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }

    private var corgiImage: some View {
        Image("overwhelmedInput")
            .resizable()
            .scaledToFit()
            .frame(width: 171, height: 155)
    }
    
    private var confirmationText: some View {
        VStack(spacing: 8) {
            Text("Are you sure you want to log out?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
        }
    }
    
    private var buttonOptions: some View {
        HStack(spacing: 16) {
            cancelButton
            deleteButton
        }
        .padding(.top, 10)
    }
    
    private var cancelButton: some View {
        Button(action: {
            isPresented = false
        }) {
            Text("Cancel")
                .fontWeight(.medium)
                .foregroundColor(Color.primarys)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.primarys)
                        .background(Color.clear)
                )
                .cornerRadius(25)
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            isPresented = false
            onLogOut()
        }) {
            Text("Log Out")
                .fontWeight(.medium)
                .foregroundColor(Color.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.primarys)
                )
        }
    }
}

// MARK: - Delete Pop Up

struct DeleteConfirmationView: View {
    @Binding var isPresented: Bool
    var onDelete: () -> Void
    

    var body: some View {
        VStack(spacing: 20) {
            corgiImage
            VStack (spacing: 12){
                confirmationText
                buttonOptions
            }

        } .frame(maxWidth: 323, maxHeight: 374)
        .padding(24)
        .background(Color.background)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }

    private var corgiImage: some View {
        Image("overwhelmedInput")
            .resizable()
            .scaledToFit()
            .frame(width: 171, height: 155)
    }
    
    private var confirmationText: some View {
        VStack(spacing: 8) {
            Text("Are you sure?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.text)
            
            Text("You want to delete your account!")
                .font(.body)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
        }
    }
    
    private var buttonOptions: some View {
        HStack(spacing: 16) {
            cancelButton
            deleteButton
        }
        .padding(.top, 10)
    }
    
    private var cancelButton: some View {
        Button(action: { isPresented = false }) {
            Text("Cancel")
                .fontWeight(.medium)
                .foregroundColor(Color.primarys)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.primarys)
                        .background(Color.clear)
                )
                .cornerRadius(25)
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            isPresented = false
            onDelete()
        }) {
            Text("Delete")
                .fontWeight(.medium)
                .foregroundColor(Color.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.primarys)
                )
        }
    }
}


struct SettingsRowView<Destination: View>: View {
    var iconName: String
    var title: String
    var destination: Destination?
    var action: (() -> Void)? = nil
    
    // MARK: Initializer
    init(iconName: String, title: String, destination: Destination? = nil, action: (() -> Void)? = nil) {
        self.iconName = iconName
        self.title = title
        self.destination = destination
        self.action = action
    }
    
    // MARK: Body
    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    rowContent
                }
            } else {
                Button(action: {
                    action?()
                }) {
                    rowContent
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var rowContent: some View {
        
        HStack(alignment: .center) {
            HStack(spacing: 12) {
                Image("notifIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Notifications")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.text)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.background)
        .cornerRadius(16)
    }
}
// MARK: - Toggle
struct SettingsToggleRowView: View {
    var iconName: String
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: 12) {
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.text)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.background)
        .cornerRadius(16)
        .buttonStyle(PlainButtonStyle())
    }
    
}



// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

#Preview {
    ProfileView()
}
