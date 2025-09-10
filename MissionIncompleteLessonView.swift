//
//  MissionIncompleteLessonView.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 4/9/2025.
//

import SwiftUI

struct MissionIncompleteLessonView: View {
    @State var goToNextView: Bool = false
    @State var selectedCharacter: String
    
    var body: some View {
        ZStack{
            Image("MissionIncompleteLessonView")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onTapGesture {goToNextView = true }
        }
        .fullScreenCover(isPresented: $goToNextView) {
            MissionView(selectedCharacter: selectedCharacter)
        }
    }
}

//#Preview {
//    MissionView(selectedCharacter: "")
//}
