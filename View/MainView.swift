//
//  MainView.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 26/03/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    
                    Group {
                        switch selectedTab {
                            case .home:
                                HomeView()
                                
                            case .statistic:
                                StatisticView()
                                
                            case .profile:
                                ProfileView()
                                
                            }
                    }
                }
                TabBar(selectedTab: $selectedTab)
                    .padding(.bottom,16)
                    
            }
            .background(Color.clear)
            .ignoresSafeArea(edges: .bottom)
            
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
