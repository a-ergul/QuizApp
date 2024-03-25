//
//  Home.swift
//  QuizApp
//
//  Created by Alpay Ergül on 25.03.2024.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Home: View {
    @State private var quizInfo: Info?
    @State private var questions: [Question] = []
    @State private var startQuiz: Bool = false
    
    /// - Anonymous User Log
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        if let info = quizInfo {
            VStack(spacing: 10){
                Text(info.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .hAlign(.center)
                
                /// Custom Label
                CustomLabel("list.bullet.rectangle.portrait", "\(questions.count)", "Multiple Choice Questions")
                    .padding(.top,20)
                
                CustomLabel("person", "\(info.peopleAttended)", "Attended the exercise")
                    .padding(.top, 5)
                
                Divider()
                    .padding(.horizontal, -15)
                    .padding(.top, 15)
                
                if !info.rules.isEmpty{
                    RulesView(info.rules)
                }
            
                CustomButton(title: "Lets Go", onClick: {
                    startQuiz.toggle()
                }, color: .orange, titleColor: .white)
                .vAlign(.bottom)
            }
            .padding(20)
            .vAlign(.top)
            .fullScreenCover(isPresented: $startQuiz ){
                QuestionsView(info: info, questions: questions)
            }
        } else {
            VStack(spacing: 20) {
                ProgressView()
                Text("Please Wait")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .task {
                do {
                    try await fetchData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// - Rules
    @ViewBuilder
    func RulesView(_ rules: [String])->some View{
        VStack(alignment: .leading, spacing: 15) {
            Text("Before your start")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 12)
            
            ForEach(rules, id: \.self) {rule in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(.gray)
                        .frame(width: 10, height: 10)
                        .offset(y: 6)
                    Text(rule)
                        .font(.callout)
                        .lineLimit(3)
                        .fontWeight(.semibold)
                }
            }
        }
    }
        
    
    /// Custom Label
    @ViewBuilder
    func CustomLabel(_ image: String,_ title: String,_ subTitle: String )->some View{
        HStack(spacing: 12){
            Image(systemName: image)
                .font(.title3)
                .frame(width:45, height: 45)
                .background{
                    Circle()
                        .fill(.gray.opacity(0.1))
                        .padding(-2)
                        .background{
                            Circle()
                                .stroke(Color(.green), lineWidth: 2)
                        }
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(.orange))
                Text(subTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
    }
    
    ///  Fetch Info and Quiz Questions
    func fetchData()async throws{
        try await loginUserAnonymous()
        let info = try await  Firestore.firestore().collection("Quiz").document("Info").getDocument().data(as: Info.self)
        let questions = try await Firestore.firestore().collection("Quiz").document("Info").collection("Questions").getDocuments()
            .documents
            .compactMap{
                try $0.data(as: Question.self)
            }
        
        /// Main Thread
        await MainActor.run(body: {
            self.quizInfo = info
            self.questions = questions
        })
    }
    /// Login User as Anonymous - Firestore
    func loginUserAnonymous()async throws{
        if !logStatus{
            try await Auth.auth().signInAnonymously()
        }
    }
    
}

#Preview {
    Home()
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
}

/// Button it Reusable

struct CustomButton: View{
    var title: String
    var onClick: ()->()
    var color: Color
    var titleColor: Color
    
    var body: some View{
        Button {
            onClick()
        } label: {
            Text(title)
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .hAlign(.center)
                .padding(.top, 15)
                .padding(.bottom, 10)
                .foregroundColor(titleColor)
                .background{
                    Rectangle()
                        .fill(Color(color))
                        .ignoresSafeArea()
                }
            
        }
        
        // Remove padding
        .padding([.bottom,.horizontal], -20)
    }
}

extension View{
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: alignment)
    }
    
    
}
