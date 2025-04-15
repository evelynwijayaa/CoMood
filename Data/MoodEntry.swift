//
//  MoodEntry.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 28/03/25.
//

import SwiftData
import SwiftUI
import Foundation

// MARK: - Enum untuk MoodType
enum MoodType: String, CaseIterable {
    case stressed
    case overwhelmed
    case neutral
    case productive
    case satisfied

    // Nilai numerik untuk perhitungan rata-rata
    var value: Int {
        switch self {
        case .stressed: return 0
        case .overwhelmed: return 30
        case .neutral: return 50
        case .productive: return 80
        case .satisfied: return 100
        }
    }

    // Warna mood untuk ditampilkan di UI
    var color: Color {
        switch self {
        case .stressed:
            return Color(red: 1.0, green: 0.9, blue: 0.8)
        case .overwhelmed:
            return Color(red: 1.0, green: 0.75, blue: 0.5)
        case .neutral:
            return .orange
        case .productive:
            return Color(red: 1.0, green: 0.5, blue: 0.2)
        case .satisfied:
            return Color(red: 0.85, green: 0.4, blue: 0.1)
        }
    }

    // Nama gambar yang sesuai dengan mood
    var imageName: String {
        return "\(self.rawValue)Input"
    }

    // Konversi dari nilai rata-rata ke MoodType
    static func fromAverageValue(_ value: Int) -> MoodType {
        switch value {
        case ..<15:
            return .stressed
        case ..<40:
            return .overwhelmed
        case ..<65:
            return .neutral
        case ..<90:
            return .productive
        default:
            return .satisfied
        }
    }

    // Konversi string ke MoodType
    static func fromString(_ string: String) -> MoodType {
        return MoodType(rawValue: string.lowercased()) ?? .neutral
    }
}

// MARK: - Model untuk menyimpan data mood di SwiftData
@Model
class MoodEntry {
    var date: Date
    var mood: String
    var activities: [String]
    var colleagues: [String]
    var productiveTime: String
    var notes: String

    init(
        date: Date,
        mood: String,
        activities: [String],
        colleagues: [String],
        productiveTime: String,
        notes: String
    ) {
        self.date = date
        self.mood = mood
        self.activities = activities
        self.colleagues = colleagues
        self.productiveTime = productiveTime
        self.notes = notes
    }
}
