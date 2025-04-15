//
//  MultipleOptionQuestion.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 07/04/25.
//

import SwiftUI

struct MultipleOptionQuestion: View {
    
    @Binding var options: [String]
    @Binding var selectedOptions: [String]
    
    var showAddButton: Bool = true
    
    var body: some View {
        VStack (spacing: 16){
            
            ForEach(options, id: \.self) { option in
                
                let isSelected = selectedOptions.contains(option)
                
                Text(option)
                    .font(Font.custom("SF Pro", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                    // Perbesar height agar pill-nya terlihat jelas
                    .frame(width: 354, height: 48, alignment: .center)
                    .background(
                        ZStack {
                            // Fill background
                            RoundedRectangle(cornerRadius: 40)
                                .fill(isSelected
                                      ? Color(red: 1, green: 0.67, blue: 0.29)   // Warna saat dipilih
                                      : Color(red: 1, green: 0.94, blue: 0.84)) // Warna default
                            
                            // Shadow
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.clear, lineWidth: 1)
                                .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 0.5)
                              
                        }
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
    }
}

#Preview {
//    MultipleOptionQuestion()
}
