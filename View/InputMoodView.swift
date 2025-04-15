//
//  InputMoodView.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 28/03/25.
//

import SwiftData
import SwiftUI

struct InputMoodView: View {
    //updated eve 9 april malem
    @AppStorage("hasCompletedMoodFlow") private var hasCompletedMoodFlow = false
@AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    //updated "Stressed" eve 8 april
    @State private var selectedMood: String = "Stressed"
    @State private var selectedActivities: [String] = []
    @State private var selectedColleagues: [String] = []
    @State private var selectedTime: String = ""
    @State private var notes: String = ""
    //updated eve alert
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var userActivities: [String] = [
        "Meeting", "Emails", "Present", "Call", "Project", "Research", "Report", "Design"
    ]
    @State private var colleagues: [String] = [
        "Team", "Manager", "Client", "Partner", "Colleague", "Supervisor"
    ]
    
    let productiveTimes = ["Morning", "Afternoon", "Midday", "Before Lunch", "Late Afternoon"]
    
    @State private var isActiveToHome: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        MoodSlider(defaultIndex: getMoodIndex(from: selectedMood), selectedMood: $selectedMood).frame(height: 194)
                        //updated eve 8 april tambahin manggil binding

                        section(title: "What did you do today at work?", content: AnyView(activitiesSection))
                        
                        section(title: "Who did you work with today?", content: AnyView(colleaguesSection))
                        
                        section(title: "When did you feel most productive today?", content: AnyView(productiveTimeSection))
                        
                        section(title: "Notes", content: AnyView(notesSection))
                        
                        checkInButton
                        //updated eve 8 april
                            .alert("Mood Checked In!", isPresented: $showAlert) {
                                    Button("OK", role: .cancel) {
                                        dismiss()
                                    }
                                } message: {
                                    Text("Your mood has been successfully saved.")
                                }
                    }
                    .padding()
                }
            } .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)            .navigationBarBackButtonHidden(true) // Hide default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Your custom back action here
                        dismiss()
                    }) {
                        Image("back")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Input Your Daily Mood")  // Center the title
                        .font(Font.custom("SF Pro", size: 20).bold())
                        .foregroundColor(Color.text)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
    }
    
    private func section(title: String, content: AnyView) -> some View {
        VStack(alignment: .center, spacing: 24) {
            Text(title)
                .font(Font.custom("SF Pro", size: 20).weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                .frame(maxWidth: .infinity, alignment: .top)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Color(red: 1, green: 0.97, blue: 0.93))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.25), radius: 12.5, x: 0, y: 1)
    }

    private var activitiesSection: some View {
        HStack{
            MultipleOption(options: $userActivities, selectedOptions: $selectedActivities, placeholderText: "Enter new activity")
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private var colleaguesSection: some View {
        HStack(alignment: .top, spacing: 8) {
            MultipleOption(options: $colleagues, selectedOptions: $selectedColleagues, placeholderText: "Enter new colleagues")
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var productiveTimeSection: some View {
        let columns = [GridItem(.adaptive(minimum: 90), spacing: 8)]

        return LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(productiveTimes, id: \.self) { productiveTime in
                let isSelected = (selectedTime == productiveTime)

                Text(productiveTime)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(isSelected ? Color.secondaryAccent : Color.selection)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 1)
                    )
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .onTapGesture {
                        selectedTime = productiveTime
                    }
            }
        }
//        .padding(.horizontal, 16)
    }



    private var notesSection: some View {
        TextEditor(text: $notes)
            .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120)
            .background(.white)
            .cornerRadius(12)
    }

    private var checkInButton: some View {
        HStack(alignment: .center, spacing: 10) {
            
            NavigationLink(destination: MainView(), isActive: $isActiveToHome) {EmptyView()}
            
            Button("Check In Mood") {
                
                if selectedMood.isEmpty || selectedActivities.isEmpty || selectedColleagues.isEmpty || selectedTime.isEmpty {
                    
                }else{
                    let newEntry = MoodEntry(
                        date: Date(),
                        mood: selectedMood,
                        activities: selectedActivities,
                        colleagues: selectedColleagues,
                        productiveTime: selectedTime,
                        notes: notes
                    )
                    modelContext.insert(newEntry) // Save to SwiftData
                    //updated eve 9 april malem
                    hasCompletedMoodFlow = true
                    hasLaunchedBefore = true
                    
                    //updated eve alert 8 april
                    showAlert = true
                    
                    isActiveToHome = true
                }
            
            }
            .font(Font.custom("SF Pro", size: 16).weight(.bold))
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 0.98, green: 0.95, blue: 0.93))
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .center)
        .background(Color(red: 0.61, green: 0.23, blue: 0.07))
        .navigationBarBackButtonHidden(true)
        .cornerRadius(32)
    }
    
    // Helper function to map selectedMood to the corresponding index for MoodSlider
    private func getMoodIndex(from mood: String) -> Int {
        let moods = ["Stressed", "Overwhelmed", "Neutral", "Productive", "Satisfied"]
        return moods.firstIndex(of: mood) ?? 0
    }
}

#Preview {
    InputMoodView()
        .environment(\.modelContext, ModelContainer.preview.mainContext)
}
