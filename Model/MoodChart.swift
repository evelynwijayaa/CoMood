//
//  MoodChart.swift
//  comood
//
//  Created by Valentinus on 08/04/25.
//
import SwiftUI

// Define MoodEntry struct first
struct MoodEntrys: Identifiable {
    let id = UUID()
    let day: String
    let stressed: Double
    let overwhelmed: Double
    let neutral: Double
    let productive: Double
    let satisfied: Double
}

struct MoodChartView: View {
    // Sample data for the week
    // Values from 0-100 for each mood
    @State private var moodData: [MoodEntrys] = [
        MoodEntrys(day: "Mon", stressed: 80, overwhelmed: 60, neutral: 40, productive: 30, satisfied: 20),
        MoodEntrys(day: "Tue", stressed: 70, overwhelmed: 65, neutral: 45, productive: 35, satisfied: 25),
        MoodEntrys(day: "Wed", stressed: 50, overwhelmed: 40, neutral: 60, productive: 65, satisfied: 70),
        MoodEntrys(day: "Thu", stressed: 30, overwhelmed: 35, neutral: 50, productive: 75, satisfied: 80),
        MoodEntrys(day: "Fri", stressed: 20, overwhelmed: 30, neutral: 40, productive: 85, satisfied: 90),
        MoodEntrys(day: "Sat", stressed: 10, overwhelmed: 20, neutral: 30, productive: 70, satisfied: 85),
        MoodEntrys(day: "Sun", stressed: 15, overwhelmed: 25, neutral: 45, productive: 75, satisfied: 80)
    ]
    
    // Current selected day
    @State private var selectedDay: String = "Mon"
    
    // Corgi color palette
    let corgiColors: [Color] = [
        Color(red: 0.99, green: 0.89, blue: 0.7),   // light cream
        Color(red: 0.99, green: 0.76, blue: 0.35),  // light orange
        Color(red: 0.99, green: 0.53, blue: 0.15),  // medium orange
        Color(red: 0.98, green: 0.41, blue: 0.1),   // dark orange
        Color(red: 0.75, green: 0.30, blue: 0.05)   // brown
    ]
    
    var body: some View {
        // Breaking up the body into smaller components to help the compiler
        mainContent
    }
    
    // Break down the view into smaller components
    var mainContent: some View {
        VStack(spacing: 20) {
            titleSection
            daySelector
            moodCirclesSection
            Spacer()
        }
    }
    
    var titleSection: some View {
        Text("Weekly Mood Chart")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
    }
    
    var daySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(moodData) { entry in
                    Button(action: {
                        selectedDay = entry.day
                    }) {
                        Text(entry.day)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedDay == entry.day ? corgiColors[3] : Color.gray.opacity(0.2))
                            .foregroundColor(selectedDay == entry.day ? .white : .primary)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var moodCirclesSection: some View {
        VStack {
            // Corgi image placeholder (replace with your asset)
            Image(systemName: "dog.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
                .foregroundColor(corgiColors[2])
            
            // Mood circles
            HStack(spacing: 5) {
                if let selectedEntry = moodData.first(where: { $0.day == selectedDay }) {
                    moodCircle(label: "Stressed", value: selectedEntry.stressed, color: corgiColors[0])
                    moodCircle(label: "Overwhelmed", value: selectedEntry.overwhelmed, color: corgiColors[1])
                    moodCircle(label: "Neutral", value: selectedEntry.neutral, color: corgiColors[2])
                    moodCircle(label: "Productive", value: selectedEntry.productive, color: corgiColors[3])
                    moodCircle(label: "Satisfied", value: selectedEntry.satisfied, color: corgiColors[4])
                }
            }
            .padding()
            
            // Legend
            legendSection
        }
    }
    
    func moodCircle(label: String, value: Double, color: Color) -> some View {
        VStack {
            Text(label)
                .font(.caption2)
                .padding(.bottom, 2)
            
            Circle()
                .fill(color)
                .frame(width: max(10, value * 0.5), height: max(10, value * 0.5))
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                )
            
            Text("\(Int(value))%")
                .font(.caption2)
                .padding(.top, 2)
        }
    }
    
    var legendSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Legend:")
                .font(.headline)
            
            HStack {
                ForEach(0..<5) { index in
                    HStack {
                        Circle()
                            .fill(corgiColors[index])
                            .frame(width: 12, height: 12)
                        
                        Text(getMoodName(index: index))
                            .font(.caption)
                    }
                    .padding(.trailing, 5)
                }
            }
        }
        .padding()
    }
    
    func getMoodName(index: Int) -> String {
        let moods = ["Stressed", "Overwhelmed", "Neutral", "Productive", "Satisfied"]
        return moods[index]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoodChartView()
    }
}
