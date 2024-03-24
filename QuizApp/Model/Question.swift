//
//  Question.swift
//  QuizApp
//
//  Created by Alpay Ergül on 24.03.2024.
//

import SwiftUI

struct Question: Identifiable, Codable{
    var id: UUID = .init()
    var question: String
    var options: [String]
    var answer: String
    
    // UI State Updates
    
    var tappedAnswer: String = ""
    
    enum CodingKeys: CodingKey{
        case question
        case options
        case answer
    }
}
