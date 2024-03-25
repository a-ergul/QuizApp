//
//  QuestionsView.swift
//  QuizApp
//
//  Created by Alpay Ergül on 25.03.2024.
//

import SwiftUI

struct QuestionsView: View {
    var info: Info
    var questions: [Question]
    
    // View Properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack{
            Button{
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .hAlign(.leading)
            
        }
        .padding(15)
        .hAlign(.center).vAlign(.top)
        .background{
            Color(.orange)
                .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ContentView()
}
