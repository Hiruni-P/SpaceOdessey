//
//  CharacterSelectionView.swift
//  SpaceOdessey
//
//  Created by Junior Nguyen on 3/9/2025.
//  UI Development by Junior Nguyen
//  Logic implemented by Elizabeth
//

import SwiftUI

struct CharacterSelectionView: View {
    let characters = ["orbie rocket", "bluey rocket", "orange rocket"]
    
    // 🔑 Make filled Images available everywhere in this struct
    let filledImages: [String: String] = [
        "orbie rocket": "orbie filled",
        "bluey rocket": "bluey filled",
        "orange rocket": "orange filled"
    ]
    
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationStack { // New SwiftUI navigation
            GeometryReader { geometry in
                ZStack {
                    // Background
                    Image("Character Selection")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    // Character Views
                    ForEach(0..<characters.count, id: \.self) { i in
                        characterImage(for: i)
                            .animation(.easeInOut, value: selectedIndex)
                    }
                    
                    // Swipe Left Button
                    Button(action: {
                        selectedIndex = (selectedIndex - 1 + characters.count) % characters.count
                    }) {
                        Image("Left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.7, height: 80)
                            .offset(x: -600, y: -250)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)
                    
                    // Swipe Right Button
                    Button(action: {
                        selectedIndex = (selectedIndex + 1) % characters.count
                    }) {
                        Image("Right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.7, height: 80)
                            .offset(x: 600, y: -250)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)
                    
                    // Continue Button with Navigation
                    NavigationLink(
                        destination: MissionView(
                            selectedCharacter: filledImages[characters[selectedIndex]] ?? characters[selectedIndex]
                        )
                    ) {
                        Image("continue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 2000, height: 500)
                            .offset(x: 180, y: -80)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)

                }
                // Add swipe gesture
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                selectedIndex = (selectedIndex + 1) % characters.count
                            } else if value.translation.width > 50 {
                                selectedIndex = (selectedIndex - 1 + characters.count) % characters.count
                            }
                        }
                )
            }
        }
    }
    
    func characterImage(for index: Int) -> some View {
        let relativeIndex = (index - selectedIndex + characters.count) % characters.count
        
        // ✅ Now uses global filledImages
        let imageName = (relativeIndex == 0) ? (filledImages[characters[index]] ?? characters[index]) : characters[index]
        
        // Positioning
        let offsetX: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        switch relativeIndex {
        case 0:
            offsetX = 0; width = 500; height = 300
        case 1:
            offsetX = 400; width = 400; height = 300
        case 2:
            offsetX = -400; width = 300; height = 300
        default:
            offsetX = 0; width = 300; height = 300
        }
        
        return AnyView(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .offset(x: offsetX, y: -100)
                .zIndex(relativeIndex == 0 ? 1 : 0)
        )
    }
}

// MARK: - Preview
struct CharacterSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterSelectionView()
    }
}
