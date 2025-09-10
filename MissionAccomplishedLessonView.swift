//
//  MissionAccomplishedLessonView.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 4/9/2025.
//

import SwiftUI

struct MissionAccomplishedLessonView: View {
    @State var goToNextView: Bool = false
    let selectedCharacter: String
    
    var body: some View {
        ZStack{
            Image("MissionAccomplishedLessonView")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {goToNextView = true }
            
        }
        
        .fullScreenCover(isPresented: $goToNextView) {
            MissionView(selectedCharacter: selectedCharacter)
        }
    }
}

//#Preview {
//    MissionAccomplishedLessonView()
//}
