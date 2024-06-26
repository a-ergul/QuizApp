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
    @State private var score: CGFloat = 0
    @State private var showScoreCard: Bool = false
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
                        .fill(Color(.blue))
                        .frame(width: progress * size.width/3, alignment: .leading)
                }
                .clipShape(Capsule())
            }
            .frame(height: 20)
            .padding(.top, 5)
            
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
            CustomButton(title: currentIndex == (questions.count - 1) ? "Finish" : "Next Question", onClick: {
                if currentIndex == (questions.count - 1) {
                    /// Score Card
                    showScoreCard.toggle()
                } else {
                    withAnimation(.easeInOut){
                        print("test")
                        currentIndex += 1
                        progress = CGFloat(currentIndex) / CGFloat(questions.count - 1)
                    }}},
                         color: .white.opacity(0.7), titleColor: .black.opacity(0.6))
        }
        .padding(15)
        .hAlign(.center).vAlign(.top)
        .background{
            Color(.orange)
                .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
        .fullScreenCover(isPresented: $showScoreCard){
            ScoreCardView(score: score / CGFloat(questions.count) * 100){
                dismiss()
            }
        }
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
                    ZStack{
                        OptionView(option, .gray)
                            .opacity(question.answer == option && question.tappedAnswer != "" ? 0 : 1)
                        OptionView(option, .green)
                            .opacity(question.answer == option && question.tappedAnswer != "" ? 1 : 0)
                        OptionView(option, .red)
                            .opacity(question.tappedAnswer == option && question.tappedAnswer != question.answer ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        guard questions[currentIndex].tappedAnswer == "" else{return}
                        withAnimation(.easeInOut) {
                            questions[currentIndex].tappedAnswer = option
                            /// Update Progress
                            if question.answer == option{
                                score += 1.0
                            }
                        }
                        
                    }
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
    
    // Score Card View
    
    struct ScoreCardView: View{
        var score: CGFloat
        var onDismiss: ()->()
        var body: some View{
            VStack{
                VStack(spacing: 10){
                    Text("Result:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 20) {
                        Text("Congratulations! You\n have score")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        // Remove Floating Points
                        
                        Text(String(format: "%.0f", score) + "%")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                            .padding(.bottom, 15)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .hAlign(.center)
                    .background {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                            .fill(.white)
                    }
                }
                .vAlign(.center)
                
                CustomButton(title: "Back to HomePage", onClick: {
                    onDismiss()
                }, color: .orange, titleColor: .white)
            }
        }}

