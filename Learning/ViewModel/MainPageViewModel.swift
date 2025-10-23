//
//  MainPageViewModel.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

// MainPageViewModel.swift
// MainPageView.swift
// MainPageViewModel.swift
import Foundation
internal import Combine

class MainPageViewModel: ObservableObject {
    @Published var currentStatus: LearningStatus
    @Published var currentWeek: [Date] = []
    @Published var selectedDate: Date = Date()
    
    private let calendar = Calendar.current

    init(subject: String, duration: LearningDuration) {
        // يجب أن يعمل هذا بعد تصحيح LearningStatus
        self.currentStatus = LearningStatus(subject: subject, duration: duration)
        self.currentWeek = []
        self.selectedDate = Date()
        updateWeek(for: Date())
    }

    // --- A. منطق التاريخ والتنقل ---
    
    func updateWeek(for date: Date) {
        // يحسب الأيام من الأحد إلى السبت للأسبوع الذي يضم التاريخ المعطى
        let today = calendar.startOfDay(for: date)
        
        // البحث عن أول يوم في الأسبوع
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else { return }
        
        // بناء مصفوفة الأيام
        currentWeek = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
    }

    func navigateWeek(by value: Int) {
        // ينتقل للأسبوع التالي أو السابق
        guard let newDate = calendar.date(byAdding: .weekOfYear, value: value, to: selectedDate) else { return }
        selectedDate = newDate
        updateWeek(for: newDate)
    }

    // --- B. منطق القيود اليومية والتجميد ---
    
    var freezesRemaining: Int {
        return currentStatus.duration.maxFreezes - currentStatus.freezesUsed
    }
    
    // خاصية محسوبة: هل تم تسجيل تفاعل اليوم (تعلم أو تجميد)؟
    var hasInteractedToday: Bool {
        guard let lastDate = currentStatus.lastInteractionDate else {
            return false
        }
        return Calendar.current.isDateInToday(lastDate)
    }

    // تحديث حالة زر "تعلم"
    var isLearnButtonEnabled: Bool {
        // 1. يجب ألا يكون قد تم التفاعل اليوم
        guard !hasInteractedToday else { return false }
        
        // 2. يجب أن تكون الأيام المتعلمة أقل من إجمالي المدة
        let totalDays: Int = currentStatus.duration == .week ? 7 : (currentStatus.duration == .month ? 30 : 365)
        return currentStatus.daysLearned < totalDays
    }
    
    // تحديث حالة زر "تجميد"
    var isFreezeButtonEnabled: Bool {
        // 1. يجب ألا يكون قد تم التفاعل اليوم
        guard !hasInteractedToday else { return false }
        
        // 2. يجب أن يكون هناك رصيد تجميد متبقي
        return freezesRemaining > 0
    }

    // تعديل دالة logAsLearned
    func logAsLearned() {
        guard isLearnButtonEnabled else { return }
        
        currentStatus.daysLearned += 1
        currentStatus.lastInteractionDate = Date() // تسجيل تاريخ التفاعل
        currentStatus.wasLastInteractionFreeze = false
        print("Logged as Learned. Total days: \(currentStatus.daysLearned)")
    }

    // تعديل دالة logAsFreezed
    func logAsFreezed() {
        guard isFreezeButtonEnabled else { return }
        
        currentStatus.freezesUsed += 1
        currentStatus.daysFreezed += 1
        currentStatus.lastInteractionDate = Date() // تسجيل تاريخ التفاعل
        currentStatus.wasLastInteractionFreeze = true
        print("Logged as Freezed. Freezes left: \(freezesRemaining)")
    }
}
