//
//  MissionAccomplishedView.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 2/9/2025.
//

import SwiftUI

struct MissionAccomplishedView: View {
    @State var goToNextView: Bool = false
    let selectedCharacter: String
    
    var body: some View {
        ZStack{
            Image("MissionAccomplishedView")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
                .onTapGesture {goToNextView = true }
            
        }
        
        .fullScreenCover(isPresented: $goToNextView) {
            MissionAccomplishedLessonView(selectedCharacter: selectedCharacter)
        }
        
    }
}

//#Preview {
//    MissionAccomplishedView()
//}
