//
//  ContentView.swift
//  comood
//
//  Created by Evelyn Wijaya on 20/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            Text("Tab Content 1")
                .tag(1)
            Text("Tab Content 2")
                .tag(2)
            Text("Tab Content 3")
                .tag(3)
        }
//        .overlay(Alignment: .bottom)
    }
}

#Preview {
        ContentView()
}
