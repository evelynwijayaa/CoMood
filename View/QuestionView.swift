//
//  QuestionView.swift
//  comood
//
//  Created by Valentinus on 08/04/25.
//


import SwiftUI
import UserNotifications

struct QuestionView: View {
    @State private var progress: Double = 25
    
    var body: some View {
        NavigationView {
            Question1(progress: $progress)
        }.navigationBarBackButtonHidden(true)
    }
}

struct ProgressBarView: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track (latar belakang progress bar)
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(red: 1, green: 0.67, blue: 0.29))
                    .frame(height: 10)
                // Bagian yang menunjukkan progres
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(red: 0.47, green: 0.23, blue: 0.19))
                    .frame(
                        width: (CGFloat(configuration.fractionCompleted ?? 0)) * geometry.size.width,
                        height: 10
                    )
            }
        }
    }
}

struct Question1: View {
    @Binding var progress: Double
    
    @State private var isActive: Bool = false
    @State private var isActiveToInput: Bool = false
    @State private var selectedQuestion1: [String] = []
    
    @State private var question1: [String] = [
        "Reading books",
        "Listening to music",
        "Cooking",
        "Playing video games",
        "Drawing"
    ]
    
    @State private var showValidationMessage: Bool = false
    
    // State untuk menampung teks "Other"
    @State private var otherText: String = ""
    @State private var showOtherTextField: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Header
            HStack(alignment: .center, spacing: 0) {
                HStack {
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(red: 0.61, green: 0.23, blue: 0.07))
                    }
                    
                    Text("ssss").foregroundStyle(.clear)
                }
                Text("1/4")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                NavigationLink(destination: MainView(), isActive: $isActiveToInput) { EmptyView() }
                
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        isActiveToInput = true
                    }) {
                        Text("skip")
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                }
                .padding(10)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // Progress Bar
            ProgressView(value: progress, total: 100)
                .frame(height: 10)
                .progressViewStyle(ProgressBarView())
                .padding(.horizontal)
            
            VStack(alignment: .center, spacing: 20) {
                VStack(spacing: 12) {
                    Text("What activities or hobbies bring you joy and relaxation?")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.98, green: 0.48, blue: 0.04))
                        .frame(width: 321, alignment: .top)
                    
                    Text("You can pick more than one.")
                        .font(Font.custom("SF Pro", size: 14))
                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    MultipleOptionQuestion(options: $question1, selectedOptions: $selectedQuestion1)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                // Navigasi ke Question2, pastikan binding progress diteruskan
                NavigationLink(destination: Question2(progress: $progress), isActive: $isActive) {
                    EmptyView()
                }
                
                if showValidationMessage {
                    Text("Please select an option")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                Button(action: {
                    if selectedQuestion1.isEmpty {
                        withAnimation {
                            showValidationMessage = true
                        }
                        // Atau Anda bisa mengatur timer untuk menghilangkannya setelah beberapa detik
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showValidationMessage = false
                            }
                        }
                    } else {
                        // Jika valid, lanjutkan ke pertanyaan berikutnya
                        progress += 25
                        isActive = true
                    }
                }) {
                    Text("Next")
                        .foregroundStyle(Color.background)
                        .font(.callout)
                        .fontWeight(.bold)
                        .frame(width: 354, height: 48, alignment: .center)
                        .background(Color(red: 0.61, green: 0.23, blue: 0.07))
                        .cornerRadius(32)
                }
            }
            .padding()
        }
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
    }
}

struct Question2: View {
    @Binding var progress: Double
    
    @State private var isActive: Bool = false
    @State private var isActiveToInput: Bool = false
    @State private var selectedQuestion2: String = ""
    
    @State private var showValidationMessage: Bool = false
    
    let question2 = [
        "Every day",
        "A few times a week",
        "Rarely",
        "Not at all"
    ]
    
    // Untuk dismiss tampilan
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Header
            HStack(alignment: .center, spacing: 0) {
                
                Button(action: {
                    progress -= 25  // Kurangi progress saat kembali
                    dismiss()       // Kembali ke tampilan sebelumnya
                }) {
                    HStack {
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(Color(red: 0.61, green: 0.23, blue: 0.07))
                        }
                        
                        Text("ssss").foregroundStyle(.clear)
                    }
                }
                Text("2/4")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                NavigationLink(destination: MainView(), isActive: $isActiveToInput) { EmptyView() }
                
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        isActiveToInput = true
                    }) {
                        Text("skip")
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                }
                .padding(10)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // Progress Bar
            ProgressView(value: progress, total: 100)
                .frame(height: 10)
                .progressViewStyle(ProgressBarView())
                .padding(.horizontal)
            
            VStack(alignment: .center, spacing: 20) {
                VStack(spacing: 12) {
                    Text("How often do you make time for your hobbies outside of work?")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.98, green: 0.48, blue: 0.04))
                        .frame(width: 321, alignment: .top)
                    
                    Text("You can pick one.")
                        .font(Font.custom("SF Pro", size: 14))
                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    ForEach(question2, id: \.self) { question in
                        let isSelected = (selectedQuestion2 == question)
                        Text(question)
                            .font(Font.custom("SF Pro", size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                            .frame(width: 354, height: 48, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(isSelected
                                          ? Color(red: 1, green: 0.67, blue: 0.29)
                                          : Color(red: 1, green: 0.94, blue: 0.84))
                                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .onTapGesture {
                                selectedQuestion2 = question
                            }
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                NavigationLink(destination: Question3(progress: $progress), isActive: $isActive) {
                    EmptyView()
                }
                
                if showValidationMessage {
                    Text("Please select an option")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                Button(action: {
                    if selectedQuestion2.isEmpty {
                        withAnimation {
                            showValidationMessage = true
                        }
                        // Atau Anda bisa mengatur timer untuk menghilangkannya setelah beberapa detik
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showValidationMessage = false
                            }
                        }
                    } else {
                        // Jika valid, lanjutkan ke pertanyaan berikutnya
                        progress += 25
                        isActive = true
                    }
                }) {
                    Text("Next")
                        .foregroundStyle(Color.background)
                        .font(.callout)
                        .fontWeight(.bold)
                        .frame(width: 354, height: 48, alignment: .center)
                        .background(Color(red: 0.61, green: 0.23, blue: 0.07))
                        .cornerRadius(32)
                }
            }
            .padding()
        }
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
    }
}

struct Question3: View {
    @Binding var progress: Double
    
    @State private var isActive: Bool = false
    @State private var isActiveToInput: Bool = false
    @State private var selectedQuestion3: String = ""
    
    let question3 = [
        "Yes, I feel happier after doing my hobby",
        "Not sure, I need to explore more",
        "No, I haven’t really noticed any difference"
    ]
    
    @State private var showValidationMessage: Bool = false
    
    // Untuk dismiss tampilan
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Header
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    progress -= 25  // Kurangi progress saat kembali
                    dismiss()       // Kembali ke tampilan sebelumnya
                }) {
                    HStack {
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(Color(red: 0.61, green: 0.23, blue: 0.07))
                        }
                        
                        Text("ssss").foregroundStyle(.clear)
                    }
                }
                Text("3/4")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                NavigationLink(destination: MainView(), isActive: $isActiveToInput) { EmptyView() }
                
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        isActiveToInput = true
                    }) {
                        Text("skip")
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                }
                .padding(10)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // Progress Bar
            ProgressView(value: progress, total: 100)
                .frame(height: 10)
                .progressViewStyle(ProgressBarView())
                .padding(.horizontal)
            
            VStack(alignment: .center, spacing: 20) {
                VStack(spacing: 12) {
                    Text("Have you noticed any hobbies or activities that improve your mood over time?")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.98, green: 0.48, blue: 0.04))
                        .frame(width: 321, alignment: .top)
                    
                    Text("You can pick one.")
                        .font(Font.custom("SF Pro", size: 14))
                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    ForEach(question3, id: \.self) { question in
                        let isSelected = (selectedQuestion3 == question)
                        Text(question)
                            .font(Font.custom("SF Pro", size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                            .frame(width: 354, height: 48, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(isSelected
                                          ? Color(red: 1, green: 0.67, blue: 0.29)
                                          : Color(red: 1, green: 0.94, blue: 0.84))
                                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .onTapGesture {
                                selectedQuestion3 = question
                            }
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                NavigationLink(destination: Question4(progress: $progress), isActive: $isActive) {
                    EmptyView()
                }
                
                if showValidationMessage {
                    Text("Please select an option")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                Button(action: {
                    if selectedQuestion3.isEmpty {
                        withAnimation {
                            showValidationMessage = true
                        }
                        // Atau Anda bisa mengatur timer untuk menghilangkannya setelah beberapa detik
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showValidationMessage = false
                            }
                        }
                    } else {
                        // Jika valid, lanjutkan ke pertanyaan berikutnya
                        progress += 25
                        isActive = true
                    }
                }) {
                    Text("Next")
                        .foregroundStyle(Color.background)
                        .font(.callout)
                        .fontWeight(.bold)
                        .frame(width: 354, height: 48, alignment: .center)
                        .background(Color(red: 0.61, green: 0.23, blue: 0.07))
                        .cornerRadius(32)
                }
            }
            .padding()
        }
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
    }
}

struct DayIcon: Identifiable {
    let id = UUID()
    let dayName: String
    let normalImage: String
    let selectedImage: String
}

struct Question4: View {
    @Binding var progress: Double
    
    @State private var isActiveToInput: Bool = false
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("selectedHour") private var selectedHourTimestamp: Double = Date().timeIntervalSince1970
    @AppStorage("selectedRepeatOption") private var selectedRepeatOption = "Custom"
    @AppStorage("selectedDays") private var selectedDaysRaw: String = ""
    
    @State private var selectedHour: Date = Date()
    @State private var selectedDays: Set<Int> = []
    @State private var showDatePickerSheet = false
    
    @State private var showingNotificationAlert = false
    @State private var showCalendarValidationMessage = false
    
    let weekdays: [DayIcon] = [
        DayIcon(dayName: "Mon", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Tue", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Wed", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Thu", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Fri", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Sat", normalImage: "date", selectedImage: "selectedDate"),
        DayIcon(dayName: "Sun", normalImage: "date", selectedImage: "selectedDate")
    ]
    
    // Untuk dismiss tampilan
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Header
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    progress -= 25  // Kurangi progress saat kembali
                    dismiss()       // Kembali ke tampilan sebelumnya
                }) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(Color(red: 0.61, green: 0.23, blue: 0.07))
                        }
                        
                        Text("ssss").foregroundStyle(.clear)
                    }
                }
                Text("4/4")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.61, green: 0.23, blue: 0.07))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                NavigationLink(destination: MainView(), isActive: $isActiveToInput) { EmptyView() }
                
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        isActiveToInput = true
                    }) {
                        Text("skip")
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                }
                .padding(10)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // Progress Bar
            ProgressView(value: progress, total: 100)
                .frame(height: 10)
                .progressViewStyle(ProgressBarView())
                .padding(.horizontal)
            
            VStack(alignment: .center, spacing: 48) {
                VStack(spacing: 12) {
                    Text("Let’s set up a daily reminder after work")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.98, green: 0.48, blue: 0.04))
                        .frame(width: 321, alignment: .top)
                    
                    Text("We'll gently nudge you at your preferred time each day.")
                        .font(Font.custom("SF Pro", size: 14))
                        .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                }
                
                //                Spacer()
                
                VStack(spacing: 20){
                    
                    // content calendar + reminder
                    // Row untuk pilih hari (calendar)
                    VStack(alignment: .center, spacing: 16) {
                        
                        Text("On which days would you like to be reminded?")
                            .font(.footnote) /*.fontWeight(.semibold)*/
                            .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                        
                        VStack(alignment: .trailing, spacing: 12) {
                            
                            HStack(spacing: 12) {
                                
                                Text("Mon")
                                    .font(.footnote) .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .frame(width: 38, alignment: .top)
                                
                                Text("Tue")
                                    .font(.footnote) .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .frame(width: 38, alignment: .top)
                                Text("Wed")
                                    .font(.footnote) .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .frame(width: 38, alignment: .top)
                                
                                Text("Thu")
                                    .font(.footnote) .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .frame(width: 38, alignment: .top)
                                
                                Text("Fri")
                                    .font(.footnote) .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .frame(width: 38, alignment: .top)
                                
                                Text("Sat")
                                    .font(.footnote) .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .frame(width: 38, alignment: .top)
                                
                                Text("Sun")
                                    .font(.footnote) .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                                    .frame(width: 38, alignment: .top)
                                
                            }
                            
                            HStack (spacing: 12){
                                ForEach(Array(weekdays.enumerated()), id: \.element.id) { (index, dayIcon) in
                                    let isSelected = selectedDays.contains(index + 1)
                                    
                                    // Jika isSelected == true, pakai selectedImage, else normalImage
                                    Image(isSelected ? dayIcon.selectedImage : dayIcon.normalImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 38, height: 38)
                                        .onTapGesture {
                                            toggleDay(index+1)
                                        }
                                }
                            }
                            
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        
                    }
                    .padding(16)
                    //                    .frame(width: 356, alignment: .bottom)
                    .background(Color(red: 1, green: 0.94, blue: 0.84))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0.5)
                    
                    
                    // Row untuk reminder time
                    
                    HStack(alignment: .center) {
                        Label("Reminder at", systemImage: "clock.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.21, green: 0.09, blue: 0.08))
                        
                        Spacer()
                        // Alternative Views and Spacers
                        Text(formattedTime(selectedHour))
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                showDatePickerSheet = true
                            }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(Color(red: 1, green: 0.94, blue: 0.84))
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
                    
                }
                
                Spacer()
                
                if showCalendarValidationMessage {
                    Text("Please select a day")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                Button(action: {
                    if selectedDays.isEmpty {
                        withAnimation {
                            showCalendarValidationMessage = true
                        }
                        // Menghilangkan pesan setelah 2 detik
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showCalendarValidationMessage = false
                            }
                        }
                        return
                    }
                    showingNotificationAlert = true
                    // Simpan nilai yang dipilih ke AppStorage
                    selectedHourTimestamp = selectedHour.timeIntervalSince1970
                    selectedDaysRaw = encodeSelectedDays(from: selectedDays)
                    
                    // Schedule notifikasi dengan nilai yang disimpan
                    scheduleNotification()
                    
                    progress += 25
                    
                    
                    isActiveToInput = true
                    
                }) {
                    Text("Finish")
                        .foregroundStyle(Color.background)
                        .font(.callout)
                        .fontWeight(.bold)
                        .frame(width: 354, height: 48, alignment: .center)
                        .background(Color(red: 0.61, green: 0.23, blue: 0.07))
                        .cornerRadius(32)
                }
            }
            .padding()
        }
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showDatePickerSheet) {
            VStack(spacing: 20) {
                Text("Select Time")
                    .font(.headline)
                    .padding(.top)
                
                DatePicker("Pick time", selection: $selectedHour, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                
                Button("Finish") {
                    showDatePickerSheet = false
                    requestNotificationPermission()
                }
                .padding()
            }
            .presentationDetents([.fraction(0.3)])
        }
        .onAppear {
            // Inisialisasi nilai dari AppStorage
            selectedHour = Date(timeIntervalSince1970: selectedHourTimestamp)
            selectedDays = decodeSelectedDays(from: selectedDaysRaw)
        }
        .onChange(of: selectedDays) { newValue in
            selectedDaysRaw = encodeSelectedDays(from: newValue)
        }
        
        .alert("“CoMood” Would Like to Send You Notifications",
               isPresented: $showingNotificationAlert) {
            
            // Tombol "Don't Allow" (membatalkan)
            Button("Don't Allow", role: .cancel) {
                // Bisa diisi logika jika pengguna menolak
                print("User chose not to allow notifications.")
            }
            
            // Tombol "Allow"
            Button("Allow") {
                // Panggil fungsi untuk meminta iOS menampilkan system prompt
                requestNotificationPermission()
            }
            
        } message: {
            Text("Notifications may include alerts, sound, and icon badges. These can be configured in Settings.")
        }
    }
    
    
    func toggleDay(_ index: Int) {
        if selectedDays.contains(index) {
            selectedDays.remove(index)
        } else {
            selectedDays.insert(index)
        }
    }
    
    func encodeSelectedDays(from set: Set<Int>) -> String {
        set.map(String.init).joined(separator: ",")
    }
    
    func decodeSelectedDays(from string: String) -> Set<Int> {
        Set(string.split(separator: ",").compactMap { Int($0) })
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Permission granted")
            } else if let error = error {
                print("❌ Error: \(error)")
            }
        }
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Untuk opsi Custom, gunakan hari yang dipilih
        let daysToSchedule = Array(selectedDays)
        
        for day in daysToSchedule {
            let content = UNMutableNotificationContent()
            content.title = "Mood Check-in"
            content.body = "Don't forget to log your mood today! 🌈"
            content.sound = .default
            
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedHour)
            dateComponents.weekday = day
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule: \(error)")
                } else {
                    print("✅ Scheduled: Weekday \(day) at \(formattedTime(selectedHour))")
                }
            }
        }
    }
}

#Preview {
//    QuestionView()
        Question4(progress: .constant(75))
}
