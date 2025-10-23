//
//  ContentViewModel.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

import SwiftUI
import Combine

// تعريف المدة الزمنية للتعلم (يجب أن يكون هنا ليكون متاحاً للكل)
public enum LearningDuration: String, CaseIterable, Codable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

public class ContentViewModel: ObservableObject {
    
    // البيانات التي تراقبها الواجهة
    @Published var subjectToLearn: String = ""
    @Published var selectedDuration: LearningDuration = .week
    
    // دالة لتنفيذ منطق عند الضغط على زر "Start learning"
    public func startLearning() {
        // يمكنك هنا حفظ البيانات في Firebase أو طباعتها
        print("Starting learning: \(subjectToLearn) for \(selectedDuration.rawValue)")
    }
}
