//
//  MissionView.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 1/9/2025.
//

import SwiftUI

struct MissionView: View {
    let selectedCharacter: String
    @State private var navigateToGame = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("Mission Briefing")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Launch Mission Button
                Button(action: {
                    // Trigger navigation
                    navigateToGame = true
                }) {
                    Image("Launch Mission Button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 100)
                }
                .offset(x: 0, y: 300)
                
                // Hidden NavigationLink to handle programmatic navigation
                NavigationLink(destination: GameView(selectedCharacter: selectedCharacter),
                               isActive: $navigateToGame) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    MissionView(selectedCharacter: "")
}

