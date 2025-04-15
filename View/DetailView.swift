//
//  DetailView.swift
//  comood
//
//  Created by Shierly Anastasya Lie on 01/04/25.
//

import SwiftUI

// updated eve 8 april
let moodImageMapping: [String: String] = [
    "Stressed": "stressedInput",
    "Overwhelmed": "overwhelmedInput",
    "Neutral": "neutralInput",
    "Productive": "productiveInput",
    "Satisfied": "satisfiedInput"
]

struct DetailView: View {
    let selectedDate: Date
    let entries: [MoodEntry]
        
        var body: some View {
            
            ZStack {
                
                Color("backgroundColor")
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    if let entry = entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
                        
                        //updated eve 8 april nambahin gambar
                        if let imageName = moodImageMapping[entry.mood] {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 130)
                        }

                        Text("\(entry.mood)")
                            .font(
                                Font.custom("SF Pro", size: 24)
                                .weight(.semibold)
                            )
                        VStack(alignment: .leading, spacing: 24) {
                            
                            Text("What did you do today at work?")
                              .font(
                                Font.custom("SF Pro", size: 20)
                                  .weight(.semibold)
                              )
                              .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                              .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            Text("\(entry.activities.joined(separator: ", "))")
                            
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color(red: 1, green: 0.97, blue: 0.93))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 1)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Who did you work with today?")
                              .font(
                                Font.custom("SF Pro", size: 20)
                                  .weight(.semibold)
                              )
                              .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                              .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            Text(" \(entry.colleagues.joined(separator: ", "))")
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color(red: 1, green: 0.97, blue: 0.93))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 1)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            Text("When did you feel most productive today?")
                              .font(
                                Font.custom("SF Pro", size: 20)
                                  .weight(.semibold)
                              )
                              .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                              .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            Text("\(entry.productiveTime)")
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color(red: 1, green: 0.97, blue: 0.93))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 1)
                        
                        VStack(alignment: .center, spacing: 24) {
                            Text("Notes")
                              .font(
                                Font.custom("SF Pro", size: 20)
                                  .weight(.semibold)
                              )
                              .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                              .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            Text("\(entry.notes)")
                                .font(Font.custom("SF Pro", size: 16))
                            .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))

                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .background(Color(red: 1, green: 0.97, blue: 0.93))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 12.5, x: 0, y: 1)
                        
                    } else {
                        Text("No data for selected date")
                    }
                }
                .padding()
    //            .navigationTitle(Text(selectedDate, style: .date))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        Text(selectedDate, style: .date)
                        .font(.headline)
                        .foregroundStyle(.primaryAccent)
                    }
                }
            }
            
        }
}

//INI PREVIEW DUMMY YA
//updated eve 8 april
#Preview {
    let dummyEntry = MoodEntry(
        date: Date(),
        mood: "Stressed",
        activities: ["Coding", "Meeting", "Brainstorming"],
        colleagues: ["Alice", "Bob", "Charlie"],
        productiveTime: "Afternoon",
        notes: "Had a great day at work. Everything went smoothly!"
    )
    
    return DetailView(selectedDate: Date(), entries: [dummyEntry])
}

/*
#Preview {
    DetailView(selectedDate: Date(), entries: [])
}
*/
