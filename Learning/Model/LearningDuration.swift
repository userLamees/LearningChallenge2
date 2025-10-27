//
//  LearningDuration.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

// LearningDuration.swift (Model)
import Foundation




enum LearningDuration: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
        
    var maxFreezes: Int {
        switch self {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }

var daysCount: Int {
    switch self {
    case .week: return 7
    case .month: return 30
    case .year: return 365
    }
}

var displayName: String {
    return self.rawValue
}
}
//
struct LearningGoal {
    var goalText: String
    var duration: LearningDuration
}
