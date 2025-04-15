//
//  MoodSlider.swift
//  comood
//
//  Created by Valentinus on 25/03/25.
//

//
//  MoodSlider.swift
//  comood
//
//  Created by Valentinus on 25/03/25.
//

import SwiftUI

public struct MoodSlider: View {
    // Data Mood
    let moodsImages = ["stressedInput", "overwhelmedInput", "neutralInput", "productiveInput", "satisfiedInput"]
    let moodNames = ["Stressed", "Overwhelmed", "Neutral", "Productive", "Satisfied"]
    
    //updated evelyn 8 april tambah binding
    @Binding var selectedMood: String
    // State
    @State private var currentIndex: Int
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    //@State private var selectedMood: String
    
    // Inisialisasi mood default pada konstruktor
    //updated evelyn 8 april ganti konstruktor
    init(defaultIndex: Int = 0, selectedMood: Binding<String>) {
        _currentIndex = State(initialValue: defaultIndex)
        self._selectedMood = selectedMood
    }
    
    /*init(defaultIndex: Int = 0) {
            _currentIndex = State(initialValue: defaultIndex)
            _selectedMood = State(initialValue: "Stressed")
        }*/
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("What is your mood today?")
                    .font(Font.custom("SF Pro", size: 20).weight(.semibold))
                    .foregroundColor(Color.text)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ZStack {
                    // Rectangle frame untuk mood yang terpilih
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 150, height: 140)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.6)
                                .stroke(Color(red: 0.21, green: 0.09, blue: 0.08), lineWidth: 1)
                        )
                    
                    // Horizontal Mood Slider
                    HStack(spacing: 16) {
                        ForEach(0..<moodsImages.count, id: \.self) { index in
                            Image(moodsImages[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: selectedMood == moodNames[index] ? 140 : 66.39,
                                       height: selectedMood == moodNames[index] ? 123 : 60)
                                .aspectRatio(contentMode: .fill)
                                .opacity(selectedMood == moodNames[index] ? 1 : 0.5)
                                .animation(.easeInOut(duration: 0.3), value: selectedMood)
                                .onTapGesture {
                                    withAnimation {
                                        currentIndex = index
                                        selectedMood = moodNames[index]
                                    }
                                }
                        }
                    }
                    .frame(width: geometry.size.width, alignment: .center)
                    .offset(x: calculateIndicatorOffset(geometry: geometry) + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                dragOffset = gesture.translation.width
                            }
                            .onEnded { gesture in
                                let threshold: CGFloat = 50
                                
                                if dragOffset > threshold && currentIndex > 0 {
                                    withAnimation(.spring()) {
                                        currentIndex -= 1
                                        selectedMood = moodNames[currentIndex]
                                    }
                                } else if dragOffset < -threshold && currentIndex < moodsImages.count - 1 {
                                    withAnimation(.spring()) {
                                        currentIndex += 1
                                        selectedMood = moodNames[currentIndex]
                                    }
                                }
                                
                                // Reset drag offset with animation
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                }
                            }
                    )
                }
                
                Text("\(selectedMood.capitalized)")
                    .font(Font.custom("SF Pro", size: 16).weight(.bold))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .zIndex(1)
        }
    }
    
    private func calculateIndicatorOffset(geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
            let itemWidth: CGFloat = 82.39
            let largeItemWidth: CGFloat = 156
            let totalWidthBeforeCurrent = CGFloat(currentIndex) * itemWidth
            let remainingWidth = CGFloat(moodsImages.count - currentIndex - 1) * itemWidth
            let centerPosition = screenWidth / 2
            let requiredOffset = centerPosition - totalWidthBeforeCurrent - (largeItemWidth / 2)
            let rightShift: CGFloat = 60
            return requiredOffset + rightShift
    }
}

//updated by evelyn 8 april
struct MoodSliderPreviewWrapper: View {
    @State private var selectedMood = "Stressed"
    
    var body: some View {
        MoodSlider(selectedMood: $selectedMood)
    }
}

#Preview {
    MoodSliderPreviewWrapper()
}

/*#Preview {
    MoodSlider()
}*/
