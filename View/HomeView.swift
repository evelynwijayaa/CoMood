//
//  HomeView.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 26/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    //updated eve 9 april malem
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @AppStorage("hasCompletedMoodFlow") private var hasCompletedMoodFlow = false // 🆕
    @State private var isShowingInputMood = false
    @AppStorage("username") var username: String = "Anonymous"
    @Environment(\.modelContext) private var modelContext
    
    //updated eve 10 april
    @State private var showWeeklyOverlay = false

    @Query(sort: \MoodEntry.date, order: .reverse) private var moodEntries: [MoodEntry]
    
    //updated eve 9 april malem
    var selectedMood: String? {
        (hasLaunchedBefore && hasCompletedMoodFlow) ? moodEntries.first?.mood : nil
    }
    var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Senin
        return cal
    }
    
    var weekRange: (start: Date, end: Date) {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: calendar.startOfDay(for: today))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        return (startOfWeek, endOfWeek)
    }
    
    var weeklyMood: [MoodEntryData] {
        var result: [MoodEntryData] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: weekRange.start),
               let entry = moodEntries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                let moodType = MoodType.fromString(entry.mood)
                result.append(MoodEntryData(date: date, mood: moodType))
            }
        }
        return result
    }
    
    var weeklyAverageValue: Int {
        guard !weeklyMood.isEmpty else { return 0 }
        let total = weeklyMood.reduce(0) { $0 + $1.mood.value }
        return total / weeklyMood.count
    }
    
    var dominantMood: MoodType {
        MoodType.fromAverageValue(weeklyAverageValue)
    }
    
    var weeklyQuote: String {
        let mood = dominantMood.rawValue.lowercased()
        return moodQuotes[mood] ?? "How has your week been?"
    }
    
    
    let activityRecommendations: [String: [String: String]] = [
        "stressed": [
            "Outdoor Activity": "Nature walk (20-30 mins)\nStretching (15 mins)",
            "Indoor Activity": "Meditation (10 mins)\nBreathing exercise"
        ],
        "neutral": [
            "Outdoor Activity": "Light jogging\nWalk in the parks",
            "Indoor Activity": "Listening to music\nReading"
        ],
        "productive": [
            "Outdoor Activity": "Running (30 mins)\nHiking",
            "Indoor Activity": "Coding side project\nOrganize workspace"
        ],
        "satisfied": [
            "Outdoor Activity": "Picnic\nOutdoor games",
            "Indoor Activity": "Watch a movie\nCook something fun"
        ],
        "overwhelmed": [
            "Outdoor Activity": "Slow walk\nSit by nature",
            "Indoor Activity": "Journaling\nWarm bath"
        ]
    ]
    let moodQuotes: [String: String] = [
        "satisfied": "An amazing week—you've truly earned that sense of pride!",
        "productive": "Your focus and drive stood strong all week—well done!",
        "neutral": "Staying balanced is a quiet win—keep it up!",
        "overwhelmed": "This week was a lot, but you made it through—be kind to yourself.",
        "stressed": "It's been tough, but you're still standing—that's strength."
    ]
    let moodNames = ["Stressed", "Overwhelmed", "Neutral", "Productive", "Satisfied"]
    var moodImageName: String {
        if let mood = selectedMood?.lowercased() {
            return "\(mood)Home" // Ini mood Hariannya disesuaikan
        } else {
            return "house"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Image("backgroundHome")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 520)
                    .ignoresSafeArea()
                    .offset(y:100)
                
                VStack {
                    headerHome
                    VStack{
                        //udpated eve 10 april
                        Button(action: {
                            withAnimation {
                                showWeeklyOverlay = true
                            }
                        }) {
                            Image("Cloud")
                                .frame(width: 345, height: 206)
                                .overlay(
                                    VStack{
                                        Text(weeklyQuote)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.primary)
                                            .frame(width: 312, height: 48)
                                            .multilineTextAlignment(.center)
                                        
                                        MoodWeekly()
                                    }.padding(.vertical,52)
                                )
                        }
                        
                        
                        if let mood = selectedMood {
                            Text("You’re feeling \(mood) today.")
                                .font(.body)
                        } else {
                            Text("You haven’t selected your mood yet.")
                                .font(.body)
                            
                        }
                        //updated eve 9 april malem
                        if selectedMood == nil {
                            Button(action: {
                                isShowingInputMood = true
                            }) {
                                Image("house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 140, height: 140)
                                    .padding()
                            }
                        } else {
                            Image(moodImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .padding()
                        }
                        
                        //Activity Reccomendation
                        VStack (spacing:16){
                            Text("Activity Recommendation")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.background)
                                .frame(maxWidth: .infinity)
                            HStack{
                                activityCard(title: "Outdoor Activity")
                                activityCard(title: "Indoor Activity")
                            }
                            
                            
                            
                        }.padding(.vertical,12)
                            .padding(.horizontal,24)
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom,98)
                .navigationBarBackButtonHidden(true)
                //updated eve 10 april
                if showWeeklyOverlay {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showWeeklyOverlay = false
                                }
                            }

                        VStack(spacing: 16) {
                            MoodWeeklyCalendar()
                        }
                        .transition(.scale)
                        .zIndex(2)
                    }
                    .zIndex(2) // biar overlay bener-bener di atas
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationDestination(isPresented: $isShowingInputMood) {
                InputMoodView()
            }

        }
    }
    
    var headerHome: some View {
        HStack{
            Text("Hi,")
                .font(.title2)
                .fontWeight(.bold)
            Text("\(username)!")
                .font(.title2)
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primaryAccent)
                .frame(width: 100,height: 40)
                .overlay(
                    HStack(alignment: .center, spacing: 16) {
                        Image("streakIcon")
                        Text("24")
                            .foregroundColor(.white)
                            .font(.custom("SF Pro", size: 20))
                    }
                )
        } .padding(.horizontal,24)
        
        
        
    }
    
    func activityCard(title: String) -> some View {
        let moodKey = selectedMood?.lowercased() ?? "neutral"
        let text = activityRecommendations[moodKey]?[title] ?? "No activities found."
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            HStack(spacing: 24) {
                Text(text)
                    .font(.caption)
                    .foregroundColor(Color.text)
            } .frame(maxWidth: .infinity,alignment: .leading)
        }
        .padding(.horizontal,16)
        .padding(.vertical,16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
    }
    
}
#Preview {
    HomeView()
}
