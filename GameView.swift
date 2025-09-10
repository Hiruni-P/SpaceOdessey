//
//  GameView.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 1/9/2025.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    let selectedCharacter: String
    let scene: GameScene

    init(selectedCharacter: String) {
        self.selectedCharacter = selectedCharacter
        self.scene = GameScene(size: CGSize(width: 400, height: 800), selectedCharacter: selectedCharacter)
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            HStack {
                Spacer()
                VStack{
                    Spacer()
                    Button(action: {
                        scene.fireLaser()
                    }) {
                        Image("laserButton")
                            .padding()
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    GameView(selectedCharacter: "orbie rocketfilled")
}
