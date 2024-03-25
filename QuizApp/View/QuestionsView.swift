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
    @State private var progress: CGFloat = 0
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
            Text(info.title)
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .hAlign(.leading)
            
            GeometryReader{
                let size = $0.size
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.black.opacity(0.2))
                    
                    Rectangle()
                        .fill(Color(.gray))
                        .frame(width: progress * size.width, alignment: .leading)
                }
                .clipShape(Capsule())
            }
            .frame(height: 20)
            .padding(.top, 10)
            
            
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
