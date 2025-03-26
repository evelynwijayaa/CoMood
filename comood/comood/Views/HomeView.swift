//
//  HomeView.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 26/03/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        Text("This is home")
        
        TabBar(selectedTab: $selectedTab)
    }
}

#Preview {
    HomeView()
}
