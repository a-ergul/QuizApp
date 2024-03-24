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
    
    /// - Anonymous User Log
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        if let info = quizInfo {
            
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
    
    ///  Fetch Info and Quiz Questions
    func fetchData()async throws{
        try await loginUserAnonymous()
        let info = try await  Firestore.firestore().collection("Quiz").document("Info").getDocument().data(as: Info.self)
        let questions = try await Firestore.firestore().collection("Quiz").document("Info").collection("Questions").getDocuments()
            .documents
            .compactMap{
                try $0.data(as: Question.self)
            }
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
