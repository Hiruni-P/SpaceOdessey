//
//  Content2View.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 1/9/2025.
//

import SwiftUI
import SpriteKit
import AVFoundation

struct Content2View: View {
    @State private var rocketOffset = CGSize(
        width: -UIScreen.main.bounds.width / 2.5,
        height: UIScreen.main.bounds.height / 4
    )
    @State private var audioPlayer: AVAudioPlayer?
    @State private var navigateToCharacterSelection = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("Wibloo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Intro Text
                Image("IntroText")
                    .resizable()
                    .frame(width: 600, height: 400)
                    .offset(x: 90, y: -30)
                
                // Buttons (behind Button1)
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { print("Settings tapped") }) {
                            Image("Settings")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 80)
                        }
                        Spacer()
                    }
                    HStack {
                        Button(action: { print("Music tapped") }) {
                            Image("Music")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 80)
                        }
                        Spacer()
                    }
                    HStack {
                        Button(action: { print("Reward tapped") }) {
                            Image("Reward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 80)
                        }
                        Spacer()
                    }
                }
                .padding(.leading, 1150)
                .padding(.top, 0)
                
                // GameLogo (behind Button1)
                Button(action: { print("GameLogo tapped") }) {
                    Image("GameLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 140)
                        .offset(x: -600, y: -450)
                }
                
                // Rocket image (behind Button1)
                Image("Zusu")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 800, height: 800)
                    .rotationEffect(.degrees(25))
                    .offset(rocketOffset)
                    .onAppear {
                        withAnimation(.easeOut(duration: 3)) {
                            rocketOffset = CGSize(
                                width: -UIScreen.main.bounds.width / 3,
                                height: 0
                            )
                        }
                        // Play audio on appear
                        playIntroAudio()
                    }
                
                // ✅ Navigation Button (topmost)
                NavigationLink(destination: CharacterSelectionView(), isActive: $navigateToCharacterSelection) {
                    EmptyView()
                }
                
                Button(action: {
                    print("Button1 tapped")
                    navigateToCharacterSelection = true
                }) {
                    Image("Button1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 3000, height: 80)
                }
                .position(x: 780 , y: 680) // keeps visual offset but ensures tappable area
            }
        }
    }
    
    // MARK: - Audio Playback
    private func playIntroAudio() {
        guard let path = Bundle.main.path(forResource: "Intro", ofType: "mp3") else {
            print("Audio file not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}

#Preview {
    Content2View()
}
