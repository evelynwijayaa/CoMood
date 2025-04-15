//
//  MultipleOption.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 27/03/25.
//

import SwiftUI

struct MultipleOption: View {
    
    //binding -> so we can modify the array from here
    @Binding var options: [String]
    @Binding var selectedOptions: [String]
    
    //optional parameters to control the placeholder text in the Alert, and whether or not we show the "+" button
    var placeholderText: String? = "Enter new"
    var showAddButton: Bool = true
    
    //for showing the Alert
    @State private var showAddOptionAlert = false
    @State private var newOptionText = ""

    private let columns = [GridItem(.adaptive(minimum: 90))]
    var body: some View {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(options, id: \.self) { option in
                    tagView(for: option)
                }
                if showAddButton {
                    addButton
                }
            }
//            .padding(.horizontal, 16)
        }
    
    // Add Button View
    private var addButton: some View {
        Button(action: {
            showAddOptionAlert = true
        }) {
            HStack(alignment: .center, spacing: 10) {
                Text("+")
                    .font(Font.custom("SF Pro", size: 14).weight(.medium))
                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(width: 38, height: 38, alignment: .center)
            .background(Color(red: 1, green: 0.86, blue: 0.66))
            .cornerRadius(24)
        }
        .alert("Add New Item", isPresented: $showAddOptionAlert) {
            TextField(placeholderText ?? "Enter new item", text: $newOptionText)
            Button("Add") {
                guard !newOptionText.isEmpty else { return }
                options.append(newOptionText)
                selectedOptions.append(newOptionText) // auto-select it
                newOptionText = ""
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enter a new item")
        }
    }
    
    // Tag View for each option
    private func tagView(for option: String) -> some View {
        let isSelected = selectedOptions.contains(option)
        
        return Text(option)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.secondaryAccent : Color.selection)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 1)
            )
            .onTapGesture {
                if selectedOptions.contains(option) {
                    selectedOptions.removeAll { $0 == option }
                } else {
                    selectedOptions.append(option)
                }
            }
    }

}

//#Preview {
//    MultipleOption()
//}
