//
//  MoodSliderView.swift
//  comood
//
//  Created by Valentinus on 25/03/25.
//

import SwiftUI

struct MoodSliderView: View {
    
    // Array emoji mood
    let moods = ["Stressed-Mood", "Neutral-Mood", "Overwhelmed-Mood", "Productive-Mood", "Satisfied-Mood"]
    
    // State untuk menyimpan mood yang dipilih
    @State private var selectedMood: String = "Stressed-Mood"
    
    // Untuk menangani drag
    @State private var dragTranslation: CGFloat = 0
    @State private var currentIndex: Int = 0  // Indeks emoji yang dipilih
    
    // Fungsi untuk menghitung indeks mood berdasarkan posisi drag
    private func getIndex(for offset: CGFloat) -> Int {
        let itemWidth: CGFloat = 120 + 20 // Ukuran emoji + spacing
        let index = Int((offset + itemWidth / 2) / itemWidth)
        return min(max(index, 0), moods.count - 1)
    }
    
    // Fungsi untuk menghitung posisi yang benar setelah drag selesai (snap-to-item)
    private func getSnapOffset(for index: Int) -> CGFloat {
        let itemWidth: CGFloat = 120 + 20 // Ukuran emoji + spacing
        return CGFloat(index) * itemWidth
    }
    
    var body: some View {
        VStack {
            Text("What is your mood today?")
                .font(.title2)
                .padding()
            
            // Kotak untuk menampilkan emoji yang dipilih
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 150, height: 140)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.21, green: 0.09, blue: 0.08), lineWidth: 1)
                )
                .overlay(
                    Image(selectedMood) // Gambar emoji yang dipilih di tengah kotak
                        .resizable()
                        .frame(width: 120, height: 120)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                )
            
            // Deskripsi mood yang dipilih
            Text("Your mood: \(selectedMood.capitalized)")
                .font(.title3)
                .padding()

            // Kotak untuk slider dan emoji
            ZStack {
                // Kotak latar belakang
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 140)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                // Emoji moods
                HStack(spacing: 20) {
                    ForEach(moods.indices, id: \.self) { index in
                        let mood = moods[index]
                        Image(mood) // Gambar emoji sesuai dengan nama dalam array moods
                            .resizable()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle()) // Untuk bentuk emoji bulat
                            .overlay(
                                Circle().stroke(selectedMood == mood ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                // Saat emoji diklik, update mood yang dipilih
                                selectedMood = mood
                                currentIndex = index
                            }
                    }
                }
                .padding()
                .offset(x: getSnapOffset(for: currentIndex)) // Menggeser seluruh emoji berdasarkan posisi indeks yang dipilih
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
                            currentIndex = index
                            dragTranslation = 0 // Reset setelah selesai drag
                        }
                )
            }
            Spacer()
        }
        .padding()
    }
}

struct MoodSliderView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSliderView()
    }
}
