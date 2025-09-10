//
//  MissionIncompleteView.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 2/9/2025.
//

import SwiftUI

struct MissionIncompleteView: View {
    @State var goToNextView: Bool = false
    let selectedCharacter: String
    
    var body: some View {
        ZStack {
            Image("MissionIncompleteView")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onTapGesture {goToNextView = true }
        }
        .fullScreenCover(isPresented: $goToNextView) {
            MissionIncompleteLessonView(selectedCharacter: selectedCharacter)
        }
    }
}

//#Preview {
//    MissionIncompleteView()
//}
