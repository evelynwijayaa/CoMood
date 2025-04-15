//
//  StatisticView.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 26/03/25.
//

import SwiftUI
import SwiftData

struct StatisticView: View {
    
    @AppStorage("username") var username: String = "Anonymous"
    
    var moodStats: [(type: MoodType, count: Int, percentage: Double)] {
        let calendar = Calendar.current
        let currentMonthEntries = entries.filter {
            calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .month)
        }
        
        let total = currentMonthEntries.count
        
        let moodCounts = Dictionary(grouping: currentMonthEntries, by: { MoodType(rawValue: $0.mood.lowercased()) ?? .neutral })
            .mapValues { $0.count }
        
        return MoodType.allCases.map { type in
            let count = moodCounts[type] ?? 0
            let percentage = total > 0 ? Double(count) / Double(total) : 0
            return (type, count, percentage)
        }
    }
    
    // Untuk kasih warna tiap mood
    func color(for mood: MoodType) -> Color {
        switch mood {
        case .stressed:
            return Color(red: 0.77, green: 0.29, blue: 0.04)
        case .overwhelmed:
            return Color(red: 0.93, green: 0.39, blue: 0.04)
        case .neutral:
            return Color(red: 0.98, green: 0.48, blue: 0.04)
        case .productive:
            return Color(red: 1, green: 0.67, blue: 0.29)
        case .satisfied:
            return Color(red: 1, green: 0.86, blue: 0.66)
        }
    }
    
    
    @Query private var entries: [MoodEntry]
    @State private var selectedDate: Date = Date()
    @State private var showDetail: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 12){
                HStack {
                    Text("Hi,")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(username)!")
                        .font(.title2)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.primaryAccent)
                        .frame(width: 100, height: 40)
                        .overlay(
                            HStack(alignment: .center, spacing: 16) {
                                Image("streakIcon")
                                Text("24")
                                    .foregroundColor(.white)
                                    .font(.custom("SF Pro", size: 20))
                            }
                        )
                } .padding(.horizontal, 24)
                    .background(Color.background)
                ScrollView {
                    VStack (spacing: 16) {
                        VStack(alignment: .center, spacing: 16) {
                            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .tint(.primaryAccent)
                                .padding()
                                .onChange(of: selectedDate) { _ in showDetail = true
                                }
                            
                            Text("Tap the date to see more details")
                                .font(
                                    Font.custom("SF Pro", size: 14)
                                        .weight(.semibold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                            
                        }
                        .padding(16)
                        .frame(width: 354, alignment: .bottom)
                        .background(Color(red: 1, green: 0.94, blue: 0.84))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0.5)
                        
                        // Invisible NavigationLink triggered by showDetail
                        NavigationLink(destination: DetailView(selectedDate: selectedDate, entries: entries), isActive: $showDetail) {
                            EmptyView()
                            
                        }

                        
                        //updated eve 8 april
                        //emotions
                        HStack {
                            Text("Emotions")
                                .font(Font.custom("SF Pro", size: 24).bold())
                                .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 24)
                        }
                        VStack(spacing:24){
                            emotionChart
                            summaryView
                        }

                        
                    }
                    .padding(.bottom, 100)
                }
            }.background(Color.background)
                .navigationBarBackButtonHidden(true)
            
        }
    }
    var emotionChart: some View {
        HStack(alignment: .bottom, spacing: 22) {
            ForEach(MoodType.allCases, id: \.self) { moodType in
                let data = moodStats.first(where: { $0.type == moodType })
                let percentage = data?.percentage ?? 0
                
                VStack(spacing: 10) {
                    Rectangle()
                        .fill(color(for: moodType))
                        .frame(width: 12, height: max(CGFloat(percentage) * 100, 6))
                        .cornerRadius(12)
                    
                    Image("\(moodType.rawValue)Input")
                        .resizable()
                        .frame(width: 40, height: 36.1516)
                    
                    Text("\(Int((percentage * 100).rounded()))%")
                        .font(.custom("SF Pro", size: 14).bold())
                        .foregroundColor(Color(red: 0.77, green: 0.29, blue: 0.04))
                }
                .frame(width: 40)
            }
        }
        .padding(24)
        .frame(width: 354)
        .background(Color(red: 1, green: 0.94, blue: 0.84))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 1)
    }
    var summaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(.custom("SF Pro", size: 24).bold())
                .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text(generateSummary(
                from: moodStats.reduce(into: [MoodType: Int]()) {
                    $0[$1.type] = Int(($1.percentage * 100).rounded())
                },
                selectedDate: selectedDate)
            )
            .font(.custom("SF Pro", size: 14))
            .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(24)
        .frame(width: 354)
        .background(Color(red: 1, green: 0.94, blue: 0.84))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 1)
    }


}


//updated eve 8 april untuk summary
extension Date {
    func formattedMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: self)
    }
}

func generateSummary(from percentages: [MoodType: Int], selectedDate: Date) -> String {
    let monthYear = selectedDate.formattedMonthYear().capitalized
    guard let dominantMood = percentages.max(by: { $0.value < $1.value })?.key else {
        return "Belum ada data untuk bulan \(monthYear)."
    }
    
    switch dominantMood {
    case .stressed:
        return "Di bulan \(monthYear) ini, kamu banyak merasa stres. Mungkin ada tekanan atau tanggung jawab besar yang kamu hadapi. Luangkan waktu untuk dirimu sendiri ya!"
    case .overwhelmed:
        return "Di bulan \(monthYear) ini, kamu terlihat cukup kewalahan. Jangan lupa untuk istirahat dan minta bantuan jika dibutuhkan."
    case .neutral:
        return "Di bulan \(monthYear) ini, kamu cenderung merasa biasa saja. Stabil itu juga bagus, lho! Tetap semangat menjalani hari-hari."
    case .productive:
        return "Di bulan \(monthYear) ini, kamu terlihat sangat produktif! Terus jaga semangatmu, karena kamu sedang dalam performa terbaikmu!"
    case .satisfied:
        return "Di bulan \(monthYear) ini, kamu merasa puas dan bersyukur. Pertahankan suasana hati positif ini dan terus nikmati prosesnya!"
    }
}


#Preview {
    StatisticView()
        .environment(\.modelContext, ModelContainer.preview.mainContext)
}
