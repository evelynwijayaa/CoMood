//
//  comoodApp.swift
//  comood
//
//  Created by Evelyn Wijaya on 20/03/25.
//

import SwiftUI
import SwiftData
@main
struct comoodApp: App {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("hasCompletedMoodFlow") private var hasCompletedMoodFlow = false
    @StateObject private var userProfile = UserProfile()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MoodEntry.self)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                hasLaunchedBefore = false
                hasCompletedMoodFlow = false // ✅ reset flow
            }
        }
    }
}
