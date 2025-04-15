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

private func iconText (for selectedTab: Tab) -> String {
    switch selectedTab {
    case .home:
        return "Home"
    case .statistic:
        return "Statistic"
    case .profile:
        return "Profile"
    }
}

struct TabBar: View {
    
    @Binding var selectedTab: Tab
    private var selectedPage: String{
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 7.08911){
                        Image(selectedTab == tab ? selectedPage : tab.rawValue)
                            .scaleEffect(selectedTab == tab ? 1.2 : 1)
                        Text(iconText(for: tab))
                            .font(Font.custom("SF Pro", size: 14))
                            .foregroundColor(Color(red: 0.6, green: 0.25, blue: 0.07))
                        }
                        .onTapGesture {withAnimation (.easeIn(duration: 0.2)){
                                selectedTab = tab
                            }
                        }
                    
                    Spacer()
                }
            }
            .frame(width: nil, height: 99)
            .background(Color(red: 0.98, green: 0.95, blue: 0.93))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.25), radius: 10.635, x: 0, y: 7)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.4)
                    .stroke(Color(red: 0.98, green: 0.48, blue: 0.04).opacity(0.5), lineWidth: 0.8)
            )
            .padding()
        } .background(Color.clear)
    }
}

#Preview {
    TabBar(selectedTab: .constant(.home))
        .previewLayout(.sizeThatFits)
}
