//
//  ContentViewModel.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

// ContentViewModel.swift
import Foundation
internal import Combine

// تأكد أن هذا class
class ContentViewModel: ObservableObject {
    
    // ⬇️ الآن سيعمل بشكل سليم بعد تعريف LearningDuration
    @Published var subjectToLearn: String = ""
    
    // ⬇️ لا يوجد خطأ Initializer هنا لأننا وضعنا قيمة افتراضية (.week)
    @Published var selectedDuration: LearningDuration = .week
    
    // **B. المنطق (Business Logic)**
    func startLearning() {
        let subject = subjectToLearn
        let duration = selectedDuration
        
        // ... (منطق البدء)
        
        print("Starting learning: \(subject) for \(duration.rawValue)")
    }
}
