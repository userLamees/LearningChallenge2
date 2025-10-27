//
//  LearningStatus.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

// LearningStatus.swift (Model)
import Foundation

enum LogType {
    case learned
    case freezed
    case none // لم يتم تسجيله بعد
}

struct LearningStatus {
    var subject: String
    var duration: LearningDuration // يتطلب استيراد LearningDuration
    var daysLearned: Int = 0
    var daysFreezed: Int = 0
    var freezesUsed: Int = 0
    
    var lastInteractionDate: Date?
    var wasLastInteractionFreeze: Bool = false
    
    var loggedStatus: [Date: LogType] = [:]
    
}
