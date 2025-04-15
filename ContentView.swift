import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var isActive: Bool = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            if self.isActive {
                //Arah Ke Page Mana??
                LandingView()
            } else {
                //SplashScreen
                VStack {
                    GIFView(gifName: "SplashScreen")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            }
        }
        //Sound
        .onAppear {
            playSplashSound()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                stopSplashSound()
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
    //Play Sound
    func playSplashSound() {
        if let soundURL = Bundle.main.url(forResource: "DogBark", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("DogBark.mp3 not found in bundle.")
        }
    }
    
    //Stop Sound
    func stopSplashSound() {
        audioPlayer?.stop()
    }
}

#Preview {
    ContentView()
}
