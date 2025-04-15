//
//  MoodWeeklyCalendar.swift
//  comood
//
//  Created by Valentinus on 10/04/25.
//
import SwiftUI

struct MoodWeeklyCalendar: View {
    // Store the current week dates and mood data
    @State private var weekDates: [Date] = []
    @State private var moodData: [Int: String] = [
        1: "Satisfied", // Monday
        2: "Productive", // Tuesday
        3: "Satisfied", // Wednesday
        4: "Productive", // Thursday
        5: "Satisfied", // Friday
        // Weekend days are empty
    ]
    
    // Define color mappings for different moods
    let moodColorMapping: [String: Color] = [
        "Stressed": Color.selectionAccent,
        "Overwhelmed": Color.selection,
        "Neutral": Color.secondaryAccent,
        "Productive": Color.secondarys,
        "Satisfied": Color(Color.primarys)
    ]
    
    // Define image mappings for different moods
    let moodImageMapping: [String: String] = [
        "Stressed": "stressedInput",
        "Overwhelmed": "overwhelmedInput",
        "Neutral": "neutralInput",
        "Productive": "productiveInput",
        "Satisfied": "satisfiedInput"
    ]
    
    // Default empty state
    let defaultBorderColor = Color("PrimaryColor")
    let defaultMood = "moodDefault"
    
    init() {
        // Initialize current week dates
        self.weekDates = getCurrentWeekDates()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Day names row
            HStack(spacing: 12) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                    Text(day)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                        .frame(width: 38, alignment: .center)
                }
            }
            
            // Mood circles row
            HStack(spacing: 12) {
                ForEach(1...7, id: \.self) { dayIndex in
                    let mood = moodData[dayIndex] ?? ""
                    
                    ZStack {
                        // Background circle
                        Circle()
                            .fill(moodForDay(dayIndex) != "" ?
                                  moodColorMapping[moodForDay(dayIndex)] ?? Color.clear :
                                  Color.white)
                            .frame(width: 38, height: 38)
                            .overlay(
                                Circle()
                                    .stroke(moodForDay(dayIndex) != "" ? Color.clear : defaultBorderColor, lineWidth: 1)
                            )
                        
                        // Mood image
                        if moodForDay(dayIndex) != "" {
                            Image(moodImageMapping[moodForDay(dayIndex)] ?? defaultMood)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        } else {
                            // Empty state - just show outline
                            Image(defaultMood)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                    }
                    .frame(width: 38, height: 38)
                }
            }
            
            // Date numbers row
            HStack(spacing: 12) {
                ForEach(Array(weekDates.enumerated()), id: \.element) { index, date in
                    // Check if this date is today
                    let isToday = Calendar.current.isDateInToday(date)
                    
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.footnote)
                        .fontWeight(isToday ? .bold : .semibold)
                        .foregroundColor(isToday ? Color.primarys : Color(red: 0.21, green: 0.09, blue: 0.08))
                        .frame(width: 38, height: 22)
                        .background(
                            isToday ?
                                RoundedRectangle(cornerRadius: 6)
                                .fill(Color.primarys.opacity(0.2))
                                : nil
                        )
                }
            }
        }
        .padding(16)
        .background(Color(red: 1, green: 0.94, blue: 0.84))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0.5)
    }
    
    // Helper function to get mood for a specific day
    private func moodForDay(_ day: Int) -> String {
        return moodData[day] ?? ""
    }
    
    // Helper function to get current week dates
    private func getCurrentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        // Find the start of the week (Monday)
        var startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        // If the first day of the week is Sunday in the current calendar
        if calendar.firstWeekday == 1 {
            startOfWeek = calendar.date(byAdding: .day, value: 1, to: startOfWeek)!
        }
        
        // Generate the array of dates for the week
        var weekDates: [Date] = []
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                weekDates.append(date)
            }
        }
        
        return weekDates
    }
}

struct MoodWeeklyCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MoodWeeklyCalendar()
    }
}
