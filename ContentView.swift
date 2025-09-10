//
//  ContentView.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 29/8/2025.
//  Contributor - Elizabeth
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var progress: CGFloat = 0
    @State private var navigate = false
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                    Image("Landing Page")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Figma progress bar frame + blue fill
                    ZStack(alignment: .leading) {
                        // Static background (can be Figma border or dull color)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 10)
                        
                        // Animated blue fill
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(red: 14/255, green: 219/255, blue: 255/255)) // #0EDBFF
                            .frame(width: 300 * progress, height: 10)
                    }
                    .frame(width: 300, height: 10)
                    .padding(.bottom, 50)

                }
                
                // Hidden NavigationLink
                NavigationLink("", destination: Content2View(), isActive: $navigate)
            }
            .onReceive(timer) { _ in
                if progress < 1 {
                    progress += 0.01
                } else {
                    navigate = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
