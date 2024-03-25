//
//  QuestionsView.swift
//  QuizApp
//
//  Created by Alpay Ergül on 25.03.2024.
//

import SwiftUI

struct QuestionsView: View {
    var info: Info
    @State var questions: [Question]
    
    // View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var progress: CGFloat = 0
    @State private var currentIndex: Int = 0
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
                .fontWeight(.bold)
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
            
            // Questions
            
            GeometryReader{_ in
                ForEach(questions.indices,id: \.self) {index in
                    
                    if currentIndex == index {
                        QuestionView(questions[currentIndex])
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
            }
            
            /// Remove Padding
            
            .padding(.horizontal, -15)
            .padding(.vertical, 15)
            CustomButton(title: "Next Question", onClick: {
                withAnimation(.easeInOut){
                    currentIndex += 1
                }
            }, color: .white.opacity(0.7), titleColor: .black.opacity(0.6))
        }
        .padding(15)
        .hAlign(.center).vAlign(.top)
        .background{
            Color(.orange)
                .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
    }
    
    /// Question View
    @ViewBuilder
    func QuestionView(_ question: Question)->some View{
        VStack(alignment: .leading, spacing: 15) {
            Text("Question \(currentIndex + 1)/\(questions.count)")
                .font(.callout)
                .foregroundColor(.gray)
                .hAlign(.leading)
            
            Text(question.question)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            VStack(spacing: 12) {
                ForEach(question.options,id: \.self){option in
                    
                }
            }
            .padding(.vertical, 20)
        }
        .padding(15)
        .hAlign(.center)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
        }
        .padding(.horizontal, 15)
    }
    /// Options View
    @ViewBuilder
    func OptionView(_ option: String,_ tint: Color)->some View{
        Text(option)
            .foregroundColor(tint)
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .hAlign(.leading)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(tint.opacity(0.15))
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(tint.opacity(tint == .gray ? 0.15 : 1),lineWidth: 2)
                    }
            }
    }
}

#Preview {
    ContentView()
}
