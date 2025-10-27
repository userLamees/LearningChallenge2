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
    
    @Published var subjectToLearn: String = ""
    @Published var selectedDuration: LearningDuration = .week
    
    init(initialSubject: String, initialDuration: LearningDuration) {
            // يجب تعيين القيم الابتدائية (مهم جداً!)
            self._subjectToLearn = Published(initialValue: initialSubject)
            self._selectedDuration = Published(initialValue: initialDuration)
            
        }
        
        init() {
            self._subjectToLearn = Published(initialValue: "Swift")
            self._selectedDuration = Published(initialValue: .week)
        }
    func startLearning() {
        let subject = subjectToLearn
        let duration = selectedDuration
        
        // ... (منطق البدء)
        
        print("Starting learning: \(subject) for \(duration.rawValue)")
    }
}
