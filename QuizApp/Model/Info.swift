//
//  Info.swift
//  QuizApp
//
//  Created by Alpay Ergül on 24.03.2024.
//

import SwiftUI


struct Info: Codable{
    var title: String
    var peopleAttended: Int
    var rules: [String]
    
    enum CodingKeys: CodingKey {
        case title
        case peopleAttended
        case rules
    }
}
