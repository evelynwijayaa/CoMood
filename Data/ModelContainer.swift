//
//  ModelContainer.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 28/03/25.
//

import SwiftData

extension ModelContainer {
    static var preview: ModelContainer = {
        let schema = Schema([MoodEntry.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true) // Hanya untuk preview
        
        let container = try! ModelContainer(for: schema, configurations: [config])
        
        Task { @MainActor in
            let context = container.mainContext
            let sampleEntry = MoodEntry(
                date: .now,
                mood: "Productive",
                activities: ["Coding", "Meeting"],
                colleagues: ["Team"],
                productiveTime: "Morning",
                notes: "Had a great day!"
            )
            context.insert(sampleEntry)
        }
        
        return container
    }()
}
