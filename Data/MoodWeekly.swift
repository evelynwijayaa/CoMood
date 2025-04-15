import SwiftData
import SwiftUI

struct MoodWeekly: View {
    @Query var moodEntries: [MoodEntry] // Ambil semua entri dari database

    var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Senin = 2
        return cal
    }

    var weekRange: (start: Date, end: Date) {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // Hitung selisih ke hari Senin
        let daysToSubtract = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: calendar.startOfDay(for: today))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        return (startOfWeek, endOfWeek)
    }

    var weeklyMood: [MoodEntryData] {
        let range = weekRange

        // Buat array kosong dari Senin sampai Minggu
        var result: [MoodEntryData] = []

        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: range.start) {
                if let entry = moodEntries.first(where: {
                    calendar.isDate($0.date, inSameDayAs: date)
                }) {
                    let moodType = MoodType.fromString(entry.mood)
                    result.append(MoodEntryData(date: date, mood: moodType))
                } else {
                    // Belum ada data untuk hari itu, bisa skip atau isi default
                }
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

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                HStack(spacing: 4) {
                    ForEach(MoodType.allCases, id: \.self) { mood in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(mood.color)
                            .frame(width: mood == dominantMood ? 120 : 44, height: 30)
                    }
                }

                HStack(spacing: 16) {
                    ForEach(0..<MoodType.allCases.count, id: \.self) { i in
                        if i == MoodType.allCases.firstIndex(of: dominantMood) {
                            VStack {
                                Image(dominantMood.imageName)
                                    .resizable()
                                    .frame(width: 59, height: 53)
                                Spacer()
                            }
                            .frame(width: 120)
                        } else {
                            Spacer().frame(width: 44)
                        }
                    }
                }
            }
            .padding(.top, 30)
            .frame(maxWidth: 312, maxHeight: 53)

            Text("Weekly Mood Average: \(weeklyAverageValue)")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}


#Preview {
    let container = try! ModelContainer(for: MoodEntry.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let calendar = Calendar(identifier: .gregorian)
    let today = Date()
    let weekday = calendar.component(.weekday, from: today)
    let daysToSubtract = (weekday + 5) % 7
    let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: calendar.startOfDay(for: today))!

    // Tambahkan data dummy dari Senin sampai Minggu
    for i in 0..<7 {
        if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
            let entry = MoodEntry(
                date: date,
                mood: MoodType.allCases[i % MoodType.allCases.count].rawValue,
                activities: ["Activity \(i+1)"],
                colleagues: ["Colleague \(i+1)"],
                productiveTime: "\(i+1) hours",
                notes: "Notes for day \(i+1)"
            )
            context.insert(entry)
        }
    }

    return MoodWeekly()
        .modelContainer(container)
}
