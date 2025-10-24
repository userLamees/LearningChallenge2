//
//  LearningDuration.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

//// LearningDuration.swift (Model)
import Foundation

enum LearningDuration: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    // يجب تعريف الخاصية المحسوبة داخل الـ Enum
    var maxFreezes: Int {
        // نستخدم 'self' هنا للإشارة إلى الحالة الحالية للـ Enum (.week, .month, .year)
        switch self {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }
}
