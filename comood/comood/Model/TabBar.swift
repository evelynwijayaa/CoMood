//
//  TabBar.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 26/03/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home
    case statistic
    case profile
}

struct TabBar: View {
    
    @Binding var selectedTab: Tab
    private var selectedPage: String{
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(selectedTab == tab ? selectedPage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.2 : 1)
                    Spacer()
                        .onTapGesture {
                            withAnimation (.easeIn(duration: 1)){
                                selectedTab = tab
                        }
                    }
                }
            }
            .frame(width: nil, height: 60)
            .background(Color(red: 0.98, green: 0.95, blue: 0.93))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.25), radius: 10.635, x: 0, y: 7)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.4)
                    .stroke(Color(red: 0.98, green: 0.48, blue: 0.04).opacity(0.5), lineWidth: 0.8)
            )
            .padding()
        }
    }
}

#Preview {
    TabBar(selectedTab: .constant(.home))
}
