//
//  NotificationsView.swift
//  comood
//
//  Created by Valentinus on 08/04/25.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var isActiveToInput: Bool = false
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("selectedHour") private var selectedHourTimestamp: Double = Date().timeIntervalSince1970
    @AppStorage("selectedRepeatOption") private var selectedRepeatOption = "Custom"
    @AppStorage("selectedDays") private var selectedDaysRaw: String = ""
    
    @State private var selectedHour: Date = Date()
    @State private var selectedDays: Set<Int> = []
    @State private var showDatePickerSheet = false
    
    @State private var showPreview = false
    @State private var showingNotificationAlert = false
    @State private var showCalendarValidationMessage = false
    
    let weekdays: [DayIcon] = [
        DayIcon(dayName: "Mon", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Tue", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Wed", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Thu", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Fri", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Sat", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Sun", normalImage: "date", selectedImage: "selectedDate")
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack (spacing:0){
                SettingsToggleRowView(iconName: "displayIcon", title: "Notification", isOn: $notificationsEnabled)
                    .padding(.top, 10)
                    .foregroundStyle(Color.text)
//                    .edgesIgnoringSafeArea(.top)
                    
                    if notificationsEnabled {
                        VStack(alignment: .center, spacing: 24) {
                            // Title and description text
                            VStack(spacing: 12) {
                                Text("Update your notifications")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.orange)
                                
                                Text("We'll gently nudge you at your preferred time each day.")
                                    .font(Font.custom("SF Pro", size: 14))
                                    .foregroundColor(Color.black)
                                    .padding(.horizontal, 24)
                            }
                            
                            // Day selection section (Horizontal Scroll)
                            VStack(alignment: .center, spacing: 12) {
                                Text("On which days would you like to be reminded?")
                                    .font(.footnote)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .padding(.horizontal, 24)
                                
                                HStack(spacing: 12) {
                                    
                                    Text("Mon")
                                        .font(.footnote) .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                        .frame(width: 38, alignment: .top)
                                    
                                    Text("Tue")
                                        .font(.footnote) .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                        .frame(width: 38, alignment: .top)
                                    Text("Wed")
                                        .font(.footnote) .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                        .frame(width: 38, alignment: .top)
                                    
                                    Text("Thu")
                                        .font(.footnote) .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                        .frame(width: 38, alignment: .top)
                                    
                                    Text("Fri")
                                        .font(.footnote) .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                        .frame(width: 38, alignment: .top)
                                    
                                    Text("Sat")
                                        .font(.footnote) .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                        .frame(width: 38, alignment: .top)
                                    
                                    Text("Sun")
                                        .font(.footnote) .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                        .frame(width: 38, alignment: .top)
                                    
                                }
                                
                                HStack (spacing: 12){
                                    ForEach(Array(weekdays.enumerated()), id: \.element.id) { (index, dayIcon) in
                                        let isSelected = selectedDays.contains(index + 1)
                                        
                                        // Jika isSelected == true, pakai selectedImage, else normalImage
                                        Image(isSelected ? dayIcon.selectedImage : dayIcon.normalImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 38, height: 38)
                                            .onTapGesture {
                                                toggleDay(index+1)
                                            }
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color(red: 1, green: 0.94, blue: 0.84))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0.5)
                            
                            // Reminder time selection
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Label("Reminder at", systemImage: "clock.fill")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    Text(formattedTime(selectedHour))
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            showDatePickerSheet = true
                                        }
                                }
                                .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color(red: 1, green: 0.94, blue: 0.84))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0.5)
                                    .padding(.horizontal, 16)
                            }
                            
                            // Calendar validation message
                            if showCalendarValidationMessage {
                                Text("Please select a day")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .transition(.opacity)
                            }
                            
                            NavigationLink(destination: ProfileView(), isActive: $isActiveToInput){EmptyView()}
                            
                            Spacer()
                            
                            // Update Notification Button
                            Button(action: {
                                if selectedDays.isEmpty {
                                    withAnimation {
                                        showCalendarValidationMessage = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showCalendarValidationMessage = false
                                        }
                                    }
                                    return
                                }
                                showingNotificationAlert = true
                                selectedHourTimestamp = selectedHour.timeIntervalSince1970
                                selectedDaysRaw = encodeSelectedDays(from: selectedDays)
                                scheduleNotification()
//                                isActiveToInput = true
                                dismiss()
                            }) {
                                Text("Update Notification")
                                    .foregroundColor(Color.white)
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .frame(width: 354, height: 48, alignment: .center)
                                    .background(Color(red: 0.61, green: 0.23, blue: 0.07))
                                    .cornerRadius(32)
                            }
                        }.padding(.top, 20)
                    }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.background)
            .sheet(isPresented: $showDatePickerSheet) {
                VStack(spacing: 20) {
                    Text("Select Time")
                        .font(.headline)
                        .padding(.top)
                    
                    DatePicker("Pick time", selection: $selectedHour, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                    Button("Done") {
                        showDatePickerSheet = false
                        requestNotificationPermission()
                    }
                    .padding()
                }
                .presentationDetents([.fraction(0.3)])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("back")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Notifications")
                        .font(Font.custom("SF Pro", size: 20).bold())
                        .foregroundColor(Color.text)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .onAppear {
                selectedHour = Date(timeIntervalSince1970: selectedHourTimestamp)
                selectedDays = decodeSelectedDays(from: selectedDaysRaw)
            }
            .onChange(of: selectedDays) { newValue in
                selectedDaysRaw = encodeSelectedDays(from: newValue)
            }
        }.navigationBarBackButtonHidden(true)
            .background(Color.background)
    }
    
    func toggleDay(_ index: Int) {
        if selectedDays.contains(index) {
            selectedDays.remove(index)
        } else {
            selectedDays.insert(index)
        }
    }
    
    func encodeSelectedDays(from set: Set<Int>) -> String {
        set.map(String.init).joined(separator: ",")
    }
    
    func decodeSelectedDays(from string: String) -> Set<Int> {
        Set(string.split(separator: ",").compactMap { Int($0) })
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Permission granted")
            } else if let error = error {
                print("❌ Error: \(error)")
            }
        }
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let daysToSchedule = Array(selectedDays)
        
        for day in daysToSchedule {
            let content = UNMutableNotificationContent()
            content.title = "Mood Check-in"
            content.body = "Don't forget to log your mood today! 🌈"
            content.sound = .default
            
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedHour)
            dateComponents.weekday = day
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule: \(error)")
                } else {
                    print("✅ Scheduled: Weekday \(day) at \(formattedTime(selectedHour))")
                }
            }
        }
    }
}

#Preview {
    NotificationSettingsView()
}


