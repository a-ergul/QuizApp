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
    
    /// - Anonymous User Log
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        if let info = quizInfo {
            VStack(spacing: 10){
                Text(info.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .hAlign(.leading)
                
                /// Custom Label
                CustomLabel("list.bullet.rectangle.portrait", "\(questions.count)", "Multiple Choice Questions")
                    .padding(.top,20)
                
                CustomLabel("person", "\(info.peopleAttended)", "Attended the exercise")
                    .padding(.top, 5)
                
                Divider()
                    .padding(.horizontal, -15)
                    .padding(.top, 15)
            }
            .padding(15)
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
    
    /// Custom Label
    @ViewBuilder
    func CustomLabel(_ image: String,_ title: String,_ subTitle: String )->some View{
        
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
