//
//  MoodSlider.swift
//  comood
//
//  Created by Valentinus on 25/03/25.
//

import SwiftUI

struct MoodSlider: View {
    
    // Array emoji mood
    let moods = ["Stressed-Mood", "Neutral-Mood", "Overwhelmed-Mood", "Productive-Mood", "Satisfied-Mood"]
    
    // State untuk menyimpan mood yang dipilih
    @State private var selectedMood: String = "Stressed-Mood"
    
    // Untuk menangani drag
    @State private var dragOffset: CGFloat = 0
    @State private var dragTranslation: CGFloat = 0
    
    // Fungsi untuk menghitung indeks mood berdasarkan posisi drag
    private func getIndex(for offset: CGFloat) -> Int {
        let itemWidth: CGFloat = 120 + 20 // Ukuran emoji + spacing
        let index = Int((offset + itemWidth / 2) / itemWidth)
        return min(max(index, 0), moods.count - 1)
    }
    
    var body: some View {
        VStack {
            Text("What is your mood today?")
                .font(.title2)
                .padding()
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 150, height: 140)
              .cornerRadius(12)
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .inset(by: 0.5)
                  .stroke(Color(red: 0.21, green: 0.09, blue: 0.08), lineWidth: 1)
              )
            
            // Scroll View untuk geser emoji secara horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(moods, id: \.self) { mood in
                        Image(mood) // Gambar emoji sesuai dengan nama dalam array moods
                            .resizable()
                            .frame(width: selectedMood == mood ? 120 : 60, height: selectedMood == mood ? 120 : 60)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle()) // Untuk bentuk emoji bulat
                            .overlay(
                                Circle().stroke(selectedMood == mood ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                // Saat emoji diklik, update mood yang dipilih
                                selectedMood = mood
                            }
                    }
                }
                .padding()
            }
            
            Text("Your mood: \(selectedMood.capitalized)")
                .font(.title3)
                .padding()
            
            Spacer()
            VStack{
                Text("What is your mood today?")
                                .font(.title2)
                                .padding()
                            
                            // Scroll View untuk geser emoji secara horizontal
                            ZStack {
                                // Kotak latar belakang
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(height: 140)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                
                                // Emoji moods
                                HStack(spacing: 20) {
                                    ForEach(moods, id: \.self) { mood in
                                        Image(mood) // Gambar emoji sesuai dengan nama dalam array moods
                                            .resizable()
                                            .frame(width: selectedMood == mood ? 120 : 60, height: selectedMood == mood ? 120 : 60)
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle()) // Untuk bentuk emoji bulat
                                            .overlay(
                                                Circle().stroke(selectedMood == mood ? Color.blue : Color.clear, lineWidth: 3)
                                            )
                                    }
                                }
                                .padding()
                                .offset(x: dragTranslation) // Menggeser seluruh emoji berdasarkan drag
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            // Mengubah offset saat drag
                                            dragTranslation = value.translation.width
                                        }
                                        .onEnded { value in
                                            // Menentukan mood yang dipilih berdasarkan posisi drag
                                            let index = getIndex(for: dragTranslation)
                                            selectedMood = moods[index]
                                            dragTranslation = 0 // Reset setelah selesai drag
                                        }
                                )
                            }
                            
                            Text("Your mood: \(selectedMood.capitalized)")
                                .font(.title3)
                                .padding()
                            
                            Spacer()
                        }
                        .padding()
        }
        
        }
    }

struct MoodSlider_Previews: PreviewProvider {
    static var previews: some View {
        MoodSlider()
    }
}
