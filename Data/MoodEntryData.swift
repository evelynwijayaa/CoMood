//
//  MoodEntryData.swift
//  comood
//
//  Created by Evelyn Wijaya on 09/04/25.
//

import SwiftUI

struct MoodEntryData: Identifiable {
    let id = UUID()
    let date: Date
    let mood: MoodType

    var dayAbbreviation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Mon, Tue, etc.
        return formatter.string(from: date)
    }
}
